import 'package:bss_mobile/src/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:bss_mobile/src/models/item_model.dart';

class ImageUtil {
  static const DEFAULT_IMAGE = 'assets/images/no-image-blur.png';

  static getImageUrl(imageId) {
    return imageId != null ? (fileApiUrl + imageId.toString()) : DEFAULT_IMAGE;
  }

  static getImage(imageId) {
    final imageURL = imageId != null ? (fileApiUrl + imageId.toString()) : DEFAULT_IMAGE;
    return (imageURL != null && imageURL.startsWith('http'))
        ? NetworkImage(
            imageURL,
          )
        : AssetImage(imageURL);
  }

  static getFadeImage(imageId) {
    final imageURL = imageId != null ? (fileApiUrl + imageId.toString()) : DEFAULT_IMAGE;
    return (imageURL != null && imageURL.startsWith('http'))
        ? FadeInImage.assetNetwork(
            placeholder: ImageUtil.DEFAULT_IMAGE,
            image: imageURL,
            fit: BoxFit.cover,
          )
        : FadeInImage(
            placeholder: AssetImage(ImageUtil.DEFAULT_IMAGE),
            image: AssetImage(imageURL),
            fit: BoxFit.cover,
          );
  }

  // static getImageUrlFromList(List<ImageDTO> imageDTOs) {
  //   return imageDTOs != null && imageDTOs.length > 0 ? (imageDTOs[0].imageUrl) : DEFAULT_IMAGE;
  // }

  static getImageUrlFromList(List<ImageDTO> imageDTOs) {
    final imageURL = imageDTOs != null && imageDTOs.length > 0 ? (imageDTOs[0].imagePath) : DEFAULT_IMAGE;
    return (imageURL != null && imageURL.startsWith('http'))
        ? NetworkImage(
            imageURL,
          )
        : AssetImage(imageURL);
  }
}
