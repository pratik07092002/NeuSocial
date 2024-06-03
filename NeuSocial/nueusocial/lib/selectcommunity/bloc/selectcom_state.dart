class SelectcomState {
  final Set<String> selectedCommunities;
  final bool isSkipButtonVisible;

  SelectcomState({
    required this.selectedCommunities,
    required this.isSkipButtonVisible,
  });

  SelectcomState copyWith({
    Set<String>? selectedCommunities,
    bool? isSkipButtonVisible,
  }) {
    return SelectcomState(
      selectedCommunities: selectedCommunities ?? this.selectedCommunities,
      isSkipButtonVisible: isSkipButtonVisible ?? this.isSkipButtonVisible,
    );
  }
}
