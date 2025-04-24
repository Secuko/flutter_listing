part of 'widgets.dart';

class AppSnackBar extends StatelessWidget {
  const AppSnackBar({
    required this.message,
    this.actionTitle,
    this.onTapAction,
    this.isWithCloseButton = false,
    super.key,
  });

  final String message;
  final String? actionTitle;
  final VoidCallback? onTapAction;
  final bool isWithCloseButton;

  static void showRequestError(
    BuildContext context,
    NetworkError? networkError,
    String? error, {
    final double paddingBottom = 30,
  }) {
    const defaultMessage = 'Что-то пошло не так';
    var errorMessage = error ?? defaultMessage;

    if (networkError != null) {
      switch (networkError.type) {
        case NetworkErrorEnum.networkError:
          errorMessage = networkError.message ?? defaultMessage;
        case NetworkErrorEnum.responseParseError:
          errorMessage = networkError.message ?? defaultMessage;
        case NetworkErrorEnum.dioAnotherError:
          errorMessage = networkError.message ?? defaultMessage;
        case NetworkErrorEnum.anotherError:
          errorMessage = networkError.message ?? defaultMessage;
      }
    }

    showShackBar(
      context,
      message: errorMessage,
      paddingBottom: paddingBottom,
    );
  }

  static void showShackBar(
    BuildContext context, {
    required final String message,
    final String? actionTitle,
    final VoidCallback? onTapAction,
    final bool isWithCloseButton = false,
    final double paddingBottom = 30,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.neutral200,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        margin: EdgeInsets.only(
          bottom: paddingBottom,
          left: 16,
          right: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        content: AppSnackBar(
          message: message,
          actionTitle: actionTitle,
          onTapAction: onTapAction,
          isWithCloseButton: isWithCloseButton,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: AppTextTheme.bodyMedium14_16,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
        if (actionTitle != null && onTapAction != null) ...[
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapAction,
            child: Text(
              actionTitle!,
              style: AppTextTheme.buttonBold14_16.copyWith(
                color: AppColors.orange800,
              ),
            ),
          ),
        ],
        if (isWithCloseButton) ...[
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: AppIcons.closeSnackbarWhite(),
          ),
        ],
      ],
    );
  }
}
