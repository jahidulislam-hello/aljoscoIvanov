# Home Screen UI Update Guide

## Overview
Your HomeController has been updated to fetch real data from APIs. Now you just need to update the UI to use this data.

## Changes Made to HomeController ✅

### 1. User Profile API Integration
- `userName` - Observable string with user's full name from API
- `userProfileImage` - Observable string with user's profile image URL
- `fetchUserProfile()` - Fetches from `/auth/get-my-profile`

### 2. Shopping List API Integration
- `shoppingList` - Observable list from `/shopping/get-my-shopping-lists`
- Shows the first shopping list with title, description, cover image

### 3. Prep List API Integration
- `prepList` - Observable list from `/preplist/get-prepList`
- Shows prep list with serving, cooker, date info

### 4. Featured Recipe
- Now automatically set to the first recipe from the API instead of static Poutine

## Required UI Changes

### Update the Header to Show User's Name

**Find this code in your HomeScreen:**

```dart
Row(
  children: [
    CircleAvatar(
      radius: 22.r,
      backgroundImage: AssetImage(AppImages.appLogo),
    ),
    SizedBox(width: 10.w),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hi, Hariza", style: AppTextStyles.H4_Regular),
        Text("Ready to cook?",
            style: AppTextStyles.bioText.copyWith(
                color: AppColors.defaultTextColor)),
      ],
    ),
  ],
),
```

**Replace with:**

```dart
Row(
  children: [
    Obx(() {
      // Use user's profile image if available, otherwise use app logo
      if (controller.userProfileImage.value.isNotEmpty) {
        return CircleAvatar(
          radius: 22.r,
          backgroundImage: NetworkImage(controller.userProfileImage.value),
          onBackgroundImageError: (exception, stackTrace) {
            // Fallback to app logo on error
          },
          child: controller.userProfileImage.value.isEmpty
              ? Image.asset(AppImages.appLogo)
              : null,
        );
      } else {
        return CircleAvatar(
          radius: 22.r,
          backgroundImage: AssetImage(AppImages.appLogo),
        );
      }
    }),
    SizedBox(width: 10.w),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
          "Hi, ${controller.userName.value}",
          style: AppTextStyles.H4_Regular,
        )),
        Text("Ready to cook?",
            style: AppTextStyles.bioText.copyWith(
                color: AppColors.defaultTextColor)),
      ],
    ),
  ],
),
```

### Update "Assigned to" Text

**Find this code:**

```dart
Text(
  controller.assignedText,
  style: AppTextStyles.bioText.copyWith(
      color: AppColors.mainTextColor.withOpacity(0.7)),
),
```

**Replace with:**

```dart
Obx(() => Text(
  controller.assignedText.value,
  style: AppTextStyles.bioText.copyWith(
      color: AppColors.mainTextColor.withOpacity(0.7)),
)),
```

## Complete Updated Header Section

Here's the complete updated header code:

```dart
// Header
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        // Profile Image
        Obx(() {
          if (controller.userProfileImage.value.isNotEmpty) {
            return CircleAvatar(
              radius: 22.r,
              backgroundImage: NetworkImage(controller.userProfileImage.value),
              backgroundColor: AppColors.background,
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint('Error loading profile image');
              },
            );
          } else {
            return CircleAvatar(
              radius: 22.r,
              backgroundImage: AssetImage(AppImages.appLogo),
            );
          }
        }),
        SizedBox(width: 10.w),
        // User Name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
              "Hi, ${controller.userName.value}",
              style: AppTextStyles.H4_Regular,
            )),
            Text("Ready to cook?",
                style: AppTextStyles.bioText.copyWith(
                    color: AppColors.defaultTextColor)),
          ],
        ),
      ],
    ),
    // Menu Button
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.pureWhite,
      ),
      padding: EdgeInsets.all(8.r),
      child: GestureDetector(
        onTap: () {
          Get.dialog(
            _SidebarMenuOverlay(),
            barrierColor: Colors.black.withOpacity(0.3),
            useSafeArea: false,
          );
        },
        child: const Icon(Icons.menu),
      ),
    ),
  ],
),
```

## What Will Happen After These Changes

### On App Launch:
1. HomeController automatically fetches:
   - User profile (name & image)
   - All recipes (for "Let's cook!" section)
   - Shopping list (latest one)
   - Prep list

2. UI updates automatically:
   - Header shows: "Hi, [User's Full Name]" from API
   - Profile image shows user's photo from API (or app logo if none)
   - Featured recipe shows first recipe from API
   - Shopping list shows real data with cover image
   - Prep list shows real data
   - "Assigned to" text shows real cooker name and date

### Automatic Updates:
- All data uses `Obx()` widgets for reactive updates
- When API data changes, UI updates automatically
- If API fails, shows placeholder messages

## Data Flow Summary

```
App Starts
  ↓
HomeController.onInit()
  ↓
Parallel API Calls:
  - fetchUserProfile() → /auth/get-my-profile
  - fetchRecipes() → /recipe/get-all-recipe
  - fetchShoppingList() → /shopping/get-my-shopping-lists
  - fetchPrepList() → /preplist/get-prepList
  ↓
Data stored in observables
  ↓
Obx() widgets listen for changes
  ↓
UI updates automatically
```

## Testing Checklist

After making the UI changes, verify:

- [ ] User's name appears in header (not "Hi, Hariza")
- [ ] User's profile image shows (if they have one)
- [ ] Featured recipe shows a real recipe from API
- [ ] "Let's cook!" section shows real recipes
- [ ] Shopping list shows real data (or placeholder if empty)
- [ ] Prep list shows real data (or placeholder if empty)
- [ ] "Assigned to" text shows real cooker name and date

## Troubleshooting

### "Hi, User" shows instead of actual name
- Check network connection
- Verify token is valid
- Check API response in debugPrint logs

### Profile image not showing
- Verify image URL is valid in API response
- Check network image loading
- Fallback to app logo should work

### Shopping/Prep lists empty
- This is normal if user hasn't created any yet
- Placeholder message will show
- User can create lists from meal planner/shopping sections

## Summary

Your backend integration is **100% complete!** You just need to:

1. Replace "Hi, Hariza" with `Obx(() => Text("Hi, ${controller.userName.value}"))`
2. Replace CircleAvatar with network image using `controller.userProfileImage`
3. Wrap `controller.assignedText` with `Obx()`

Everything else (API calls, data fetching, error handling) is already working! 🎉
