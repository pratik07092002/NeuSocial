abstract class SelectcomEvent {}

class ToggleCommunitySelection extends SelectcomEvent {
  final String community;

  ToggleCommunitySelection(this.community);
}
