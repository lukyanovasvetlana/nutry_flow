import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nutrition_search_cubit.dart';

class FoodSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final String? hintText;

  const FoodSearchBar({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    this.hintText,
  }) : super(key: key);

  @override
  State<FoodSearchBar> createState() => _FoodSearchBarState();
}

class _FoodSearchBarState extends State<FoodSearchBar> {
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = widget.focusNode.hasFocus && 
                        widget.controller.text.isNotEmpty;
    });
  }

  void _onTextChanged(String value) {
    setState(() {
      _showSuggestions = value.isNotEmpty && widget.focusNode.hasFocus;
    });
    
    widget.onChanged(value);
    
    // Get search suggestions for non-empty queries
    if (value.trim().isNotEmpty && value.length >= 2) {
      context.read<NutritionSearchCubit>().getSearchSuggestions(value);
    }
  }

  void _clearSearch() {
    widget.controller.clear();
    widget.onChanged('');
    setState(() {
      _showSuggestions = false;
    });
    context.read<NutritionSearchCubit>().clearSearch();
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    widget.onSubmitted(suggestion);
    widget.focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Поиск продуктов...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: _onTextChanged,
          onSubmitted: (value) {
            widget.onSubmitted(value);
            setState(() {
              _showSuggestions = false;
            });
          },
          textInputAction: TextInputAction.search,
        ),
        
        // Search suggestions
        if (_showSuggestions)
          BlocBuilder<NutritionSearchCubit, NutritionSearchState>(
            builder: (context, state) {
              if (state is NutritionSearchSuggestions) {
                return Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = state.suggestions[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.search, size: 20),
                        title: Text(suggestion),
                        onTap: () => _selectSuggestion(suggestion),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
} 