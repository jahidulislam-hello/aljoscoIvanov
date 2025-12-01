import 'package:freshbite/features/home/home_new/cooking_model.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class CookingSkillsController extends GetxController {
  late VideoPlayerController videoController;
  final isPlaying = false.obs;
  final isMuted = false.obs;
  final volume = 1.0.obs;

  // Static skill data (non-reactive)
  final skill = CookingSkillModel(
    title: "How to Chop Herbs",
    videoUrl: "assets/video/cook.mp4",
    description:
    "Learn how to chop herbs efficiently for better texture and flavor.",
  );

  @override
  void onInit() {
    super.onInit();
    videoController =
    VideoPlayerController.asset(skill.videoUrl) // Use .asset for local file
      ..initialize().then((_) {
        update(); // Triggers GetBuilder rebuild
      });
  }

  void togglePlay() {
    if (videoController.value.isPlaying) {
      videoController.pause();
      isPlaying(false);
    } else {
      videoController.play();
      isPlaying(true);
    }
  }

  void seekForward() {
    final current = videoController.value.position;
    videoController.seekTo(current + const Duration(seconds: 10));
  }

  void seekBackward() {
    final current = videoController.value.position;
    final target = current - const Duration(seconds: 10);
    videoController.seekTo(target < Duration.zero ? Duration.zero : target);
  }

  void toggleMute() {
    if (isMuted.value) {
      videoController.setVolume(volume.value);
      isMuted(false);
    } else {
      videoController.setVolume(0);
      isMuted(true);
    }
  }

  void setVolume(double value) {
    volume(value);
    if (!isMuted.value) {
      videoController.setVolume(value);
    }
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
