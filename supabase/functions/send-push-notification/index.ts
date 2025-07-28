import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface NotificationPayload {
  tokens: string[]
  title: string
  body: string
  data?: Record<string, any>
}

interface FirebaseMessage {
  message: {
    token?: string
    topic?: string
    notification?: {
      title: string
      body: string
    }
    data?: Record<string, string>
    android?: {
      priority: 'normal' | 'high'
      notification?: {
        title: string
        body: string
        icon?: string
        color?: string
        sound?: string
        click_action?: string
      }
    }
    apns?: {
      payload: {
        aps: {
          alert: {
            title: string
            body: string
          }
          sound?: string
          badge?: number
        }
      }
    }
  }
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { tokens, title, body, data }: NotificationPayload = await req.json()

    if (!tokens || !Array.isArray(tokens) || tokens.length === 0) {
      throw new Error('Invalid tokens array')
    }

    if (!title || !body) {
      throw new Error('Title and body are required')
    }

    // Get Firebase server key from environment
    const firebaseServerKey = Deno.env.get('FIREBASE_SERVER_KEY')
    if (!firebaseServerKey) {
      throw new Error('Firebase server key not configured')
    }

    const messages: FirebaseMessage[] = tokens.map(token => ({
      message: {
        token,
        notification: {
          title,
          body,
        },
        data: data ? Object.fromEntries(
          Object.entries(data).map(([key, value]) => [key, String(value)])
        ) : undefined,
        android: {
          priority: 'high',
          notification: {
            title,
            body,
            icon: 'ic_launcher',
            color: '#4CAF50',
            sound: 'default',
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
          },
        },
        apns: {
          payload: {
            aps: {
              alert: {
                title,
                body,
              },
              sound: 'default',
              badge: 1,
            },
          },
        },
      },
    }))

    // Send notifications to Firebase
    const results = await Promise.allSettled(
      messages.map(async (message) => {
        const response = await fetch('https://fcm.googleapis.com/fcm/send', {
          method: 'POST',
          headers: {
            'Authorization': `key=${firebaseServerKey}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(message),
        })

        if (!response.ok) {
          const errorText = await response.text()
          throw new Error(`Firebase API error: ${response.status} - ${errorText}`)
        }

        const result = await response.json()
        return result
      })
    )

    // Process results
    const successful = results.filter(result => result.status === 'fulfilled').length
    const failed = results.filter(result => result.status === 'rejected').length

    console.log(`Notification sent: ${successful} successful, ${failed} failed`)

    return new Response(
      JSON.stringify({
        success: true,
        message: `Notifications sent: ${successful} successful, ${failed} failed`,
        results: results.map((result, index) => ({
          token: tokens[index],
          success: result.status === 'fulfilled',
          error: result.status === 'rejected' ? (result as PromiseRejectedResult).reason?.message : null,
        })),
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )

  } catch (error) {
    console.error('Error sending notification:', error)

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
}) 