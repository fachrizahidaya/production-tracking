import 'package:flutter/material.dart';

class CustomTheme {
  BoxDecoration cardTheme() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      border: Border.all(
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        boxShadowTheme(),
      ],
    );
  }

  BoxShadow boxShadowTheme() {
    return BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: 0,
      blurRadius: 2,
      offset: const Offset(0, 2), // changes position of shadow
    );
  }

  BoxDecoration containerCardDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      color: Colors.white,
    );
  }

  BoxDecoration containerBottomSheetDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      color: Colors.white,
    );
  }

  BoxDecoration inputStaticDecorationRequired() {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          12.0,
        ),
      ),
      border: Border.all(
        width: 0.5,
        color: Colors.transparent,
      ),
      color: Colors.white,
    );
  }

  BoxDecoration inputStaticDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            12.0,
          ),
        ),
        border: Border.all(
          width: 0.5,
          color: colors('base'),
        ),
        color: Colors.white);
  }

  InputDecoration inputDecoration([
    String? hintTextString,
    Icon? prefIcon,
    Icon? suffIcon,
  ]) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: colors('base'),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: colors('base'),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: colors('base'),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.red.shade500,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.red.shade500,
        ),
      ),
      hintText: hintTextString,
      hintStyle: const TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: prefIcon,
      suffixIcon: suffIcon,
    );
  }

  InputDecoration inputDateDecoration(
      {String? hintTextString,
      bool? clearable,
      Function()? onPressClear,
      required bool hasValue}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: colors('base'),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.black87,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: colors('base'),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.red.shade500,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.red.shade500,
        ),
      ),
      hintText: hintTextString,
      hintStyle: const TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.w400,
      ),
      suffixIcon: hasValue
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onPressClear,
            )
          : null,
    );
  }

  InputDecoration inputTimeDecoration([String? hintTextString]) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
          borderSide: BorderSide(
            width: 0.5,
            color: colors('base'),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.black87,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
          borderSide: BorderSide(
            width: 0.5,
            color: colors('base'),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.red.shade500,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.red.shade500,
          ),
        ),
        hintText: hintTextString,
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          Icons.av_timer_outlined,
          color: colors('base'),
        ));
  }

  InputDecoration inputDisableDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
        borderSide: BorderSide(
          width: 0.5,
          color: colors('base'),
        ),
      ),
      enabled: false,
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case "Belum Diproses":
      case "Belum Dibayar":
      case "Diproses":
      case "Dikirim":
      case "Tidak Aktif":
        return Colors.grey.shade500;
      case "Dibayar Sebagian":
      case "Diproses Sebagian":
      case "Dikirim Sebagian":
      case "Diterima Sebagian":
      case "Ditutup Belum Dibayar":
      case "Panen Awal":
        return Colors.orange.shade200;
      case "Lunas":
      case "Terproses":
      case "Diterima":
      case "Dibayar":
      case "Permintaan Ditutup Lunas":
      case "Aktif":
        return Colors.green.shade100;
      case "Difaktur":
      case "Ditutup":
      case "Ditutup Lunas":
      case "Panen Uang":
        return Colors.indigo.shade300;
      case "Dibatalkan":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade500;
    }
  }

  Color statusTextColor(String status) {
    switch (status) {
      case "Belum Diproses":
      case "Belum Dibayar":
      case "Diproses":
      case "Dikirim":
      case "Tidak Aktif":
        return Colors.white;
      case "Dibayar Sebagian":
      case "Diproses Sebagian":
      case "Dikirim Sebagian":
      case "Diterima Sebagian":
      case "Ditutup Belum Dibayar":
      case "Panen Awal":
        return Colors.orange.shade800;
      case "Lunas":
      case "Terproses":
      case "Diterima":
      case "Dibayar":
      case "Permintaan Ditutup Lunas":
      case "Aktif":
        return Colors.green.shade900;
      case "Difaktur":
      case "Ditutup":
      case "Ditutup Lunas":
      case "Panen Uang":
        return Colors.white;
      case "Dibatalkan":
        return Colors.red.shade800;
      default:
        return Colors.white;
    }
  }

  Color buttonColor(String name) {
    switch (name) {
      case 'base':
        return const Color.fromRGBO(18, 69, 115, 1);
      case 'primary':
        return const Color.fromRGBO(69, 97, 219, 1);
      case 'warning':
        return const Color.fromRGBO(209, 135, 0, 1);
      case 'In Progress':
        return const Color.fromRGBO(28, 183, 214, 1);
      case 'Finish':
      case 'Completed':
        return const Color.fromRGBO(23, 199, 113, 1);
      case 'danger':
      case 'Closed':
        return const Color.fromRGBO(231, 0, 11, 1);
      default:
        return const Color.fromRGBO(148, 163, 184, 1);
    }
  }

  Color colors(String name) {
    switch (name) {
      case 'base':
        // return const Color.fromRGBO(30, 41, 59, 1);
        return const Color.fromRGBO(18, 69, 115, 1);
      case 'primary':
        return const Color.fromRGBO(69, 97, 219, 1);
      case 'secondary':
        return const Color.fromRGBO(113, 113, 123, 1);
      case 'warning':
        return const Color.fromRGBO(255, 141, 52, 1);
      case 'success':
        return const Color.fromRGBO(23, 199, 113, 1);
      case 'danger':
        return const Color.fromRGBO(231, 0, 11, 1);
      case 'info':
        return const Color.fromRGBO(148, 163, 184, 1);
      case 'text-primary':
        return Colors.black;
      case 'text-secondary':
        return Colors.black54;
      case 'text-tertiary':
        return Colors.black38;
      default:
        return const Color.fromRGBO(148, 163, 184, 1);
    }
  }

  FontWeight fontWeight(type) {
    switch (type) {
      case 'thin':
        return FontWeight.w200;
      case 'normal':
        return FontWeight.w400;
      case 'semibold':
        return FontWeight.w600;
      case 'bold':
        return FontWeight.w800;
      case 'superbold':
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }

  double fontSize(type) {
    switch (type) {
      case 'xs':
        return 10;
      case 'sm':
        return 12;
      case 'md':
        return 14;
      case 'lg':
        return 16;
      case 'xl':
        return 20;
      case '2xl':
        return 24;
      case '3xl':
        return 28;
      case '4xl':
        return 30;
      case '5xl':
        return 32;
      default:
        return 14;
    }
  }

  BoxDecoration defaultButton() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(8),
      ),
      border: Border.all(
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  ButtonStyle primaryButton() {
    return TextButton.styleFrom(
      backgroundColor: CustomTheme().colors('base'),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: CustomTheme().colors('base'),
        ),
      ),
    );
  }

  ButtonStyle secondaryButton() {
    return TextButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: Colors.black87,
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.black26,
        ),
      ),
    );
  }

  ButtonStyle disabledButton() {
    return TextButton.styleFrom(
      backgroundColor: Colors.grey.shade300,
      foregroundColor: Colors.grey.shade600,
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  SizedBox hGap(size) {
    switch (size) {
      case 'xs':
        return const SizedBox(width: 2);
      case 'sm':
        return const SizedBox(width: 4);
      case 'md':
        return const SizedBox(width: 6);
      case 'lg':
        return const SizedBox(width: 8);
      case 'xl':
        return const SizedBox(width: 12);
      case '3xl':
        return const SizedBox(width: 20);
      case '4xl':
        return const SizedBox(width: 24);
      case '5xl':
        return const SizedBox(width: 30);
      default:
        return const SizedBox(width: 16);
    }
  }

  SizedBox vGap(size) {
    switch (size) {
      case 'xs':
        return const SizedBox(height: 2);
      case 'sm':
        return const SizedBox(height: 4);
      case 'md':
        return const SizedBox(height: 6);
      case 'lg':
        return const SizedBox(height: 8);
      case 'xl':
        return const SizedBox(height: 12);
      case '2xl':
        return const SizedBox(height: 16);
      case '3xl':
        return const SizedBox(height: 20);
      case '4xl':
        return const SizedBox(height: 24);
      case '5xl':
        return const SizedBox(height: 30);
      default:
        return const SizedBox(height: 16);
    }
  }

  EdgeInsets padding(type) {
    switch (type) {
      case 'card':
        return const EdgeInsets.all(12);
      case 'content':
        return const EdgeInsets.all(16);
      case 'list-card':
        return const EdgeInsets.all(12);
      default:
        return const EdgeInsets.all(16);
    }
  }

  Row horizontalLineBottomSheet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          height: 4,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
