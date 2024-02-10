import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'ta', 'hi', 'mr'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? taText = '',
    String? hiText = '',
    String? mrText = '',
  }) =>
      [enText, taText, hiText, mrText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Login
  {
    'otc9ql8a': {
      'en': 'Email',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'w46mlavo': {
      'en': 'Password',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'hif2zirj': {
      'en': 'Are you a new  user?',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'rmmyljoi': {
      'en': 'Login',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'd33kgsv3': {
      'en': ' Login',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'o4pfpt1k': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // MyProducts
  {
    'cber24dp': {
      'en': 'Refresh',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'h7jabvk7': {
      'en': 'My Products',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ejrofb4w': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Product
  {
    'ig0wgab0': {
      'en': 'Cancel',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'l4mk3qud': {
      'en': 'Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'hwdjdhaw': {
      'en': 'Brand',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'hli6diki': {
      'en': 'Size',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ein5h3rf': {
      'en': 'Count',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'carxts5n': {
      'en': 'Category',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'exqgadqt': {
      'en': 'Price',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '07z16ax2': {
      'en': 'Description',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'z6tjk50v': {
      'en': 'Update',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '9cw2sm99': {
      'en': 'Product',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '25mtfmmi': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Upload
  {
    'hag7k94y': {
      'en': 'Text | Voice',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '4wentwe5': {
      'en': 'Record',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'niraq3oe': {
      'en': 'Transcribe',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'gdsr00d5': {
      'en': 'Save',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'kiwr3sn8': {
      'en': 'Image',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ltfmkdoi': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'd33mm7gg': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'n1n2ornc': {
      'en': 'Save',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ktbdolgq': {
      'en': 'Upload',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'g1s01wlq': {
      'en': 'Add',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // ProductLibrary
  {
    'pvkoi7o8': {
      'en': 'Refresh',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'h4lqutfz': {
      'en': 'Library',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '7vrhcu06': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Signup
  {
    'py5qbhcx': {
      'en': 'Full Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'wu10tki0': {
      'en': 'Email',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'jbytavj4': {
      'en': 'Password',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'wpm2y6sa': {
      'en': 'Confirm Password',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'mixnk07m': {
      'en': 'Are you an existing user?',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '7leh30hg': {
      'en': 'Sign Up',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '6eg27085': {
      'en': 'Sign Up',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'bfni3wg2': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Settings
  {
    '71o4k9zm': {
      'en': 'Import Drive',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'd36tqhl5': {
      'en': 'Import Sheet',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'aczzrkfs': {
      'en': 'Export Sheet',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'hra34ntr': {
      'en': 'Settings',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'bam06h7a': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // History
  {
    '4xlu5ow0': {
      'en': 'Refresh',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '5dlysxrz': {
      'en': 'Sync',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'srlglrpk': {
      'en': 'History',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '1k463dc3': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Queue
  {
    'pluezd9j': {
      'en': 'Text',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'icmbkrbf': {
      'en': 'Upload',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ee8d7igl': {
      'en': 'Image',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'qf33jqk5': {
      'en': 'Upload',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ckgdzhtt': {
      'en': 'Queue',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'sy312wj0': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Profile
  {
    'jdixdtxe': {
      'en': 'Full Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'y69ej3fc': {
      'en': 'Email',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'wlepbuev': {
      'en': 'Update Profile',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'k78g12k8': {
      'en': 'Password',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'gio1eogo': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'coxga9lj': {
      'en': 'Delete Account',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '9ad7gclc': {
      'en': 'Profile',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'bp63f5hr': {
      'en': 'Home',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Sidebar
  {
    'dxzf7t2r': {
      'en': 'My Products    ',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'uz0y5nxj': {
      'en': 'Upload             ',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '0iwkf5ad': {
      'en': 'Library             ',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'dr3d4bz0': {
      'en': 'Queue            ',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'w8e4c2gd': {
      'en': 'History            ',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // MyProductCard
  {
    'nz8d1quk': {
      'en': 'Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'm2327or3': {
      'en': 'Brand',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '8cfs1zi0': {
      'en': 'Size',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'db5go1fb': {
      'en': 'Price',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '64c18aqi': {
      'en': 'Description',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '43t525o9': {
      'en': 'Edit',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'hbqixay9': {
      'en': 'Delete',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // LanguageSelect
  {
    'f8pknwau': {
      'en': 'English',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'g1qxfofz': {
      'en': 'Hindi',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'fdldtqcn': {
      'en': 'Marathi',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'qj5bcyg5': {
      'en': 'Tamil',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'jvngwzz8': {
      'en': 'Select Language',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'iq1c17uo': {
      'en': 'Search for an item...',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // HistoryCard
  {
    'g2xrlusn': {
      'en': 'Content',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '4ei9xmsc': {
      'en': 'Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'jx9wjzbi': {
      'en': 'Status',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'mjyhzcdg': {
      'en': 'Last Update',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'zqf3kxq4': {
      'en': 'Error',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // ThemeSelect
  {
    'b1wa11x8': {
      'en': 'Light Mode',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '11i8cw46': {
      'en': 'Dark Mode',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // UploadText
  {
    'ixs2ittn': {
      'en': 'Text',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // UploadImage
  {
    '59xjl2fr': {
      'en': 'Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // ProductLibraryCard
  {
    '9ry9clfh': {
      'en': 'Name',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'umvhi1jx': {
      'en': 'Brand',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'e2qbbdw0': {
      'en': 'Size',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'irzjgdyw': {
      'en': 'Price',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'jn88uupu': {
      'en': 'Description',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '3o2y9ik0': {
      'en': 'Add',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // viewSourceCard
  {
    'vydoahb2': {
      'en': 'Source',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
  // Miscellaneous
  {
    '46tof1nq': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'zprszlbl': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'e9jg6bcl': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '5wp4gx5l': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'ub4x7r2t': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '67rspy3w': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'k7t0p2l6': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'vlwhu6uz': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'b25axeyr': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'gkdbvjv3': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '1cndgtxc': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'nwroe6xi': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '3alfavh5': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'jxh7tfi0': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'bgtihr9w': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'pidnkbuu': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'fn6p8ey8': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'm3wdus9s': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'o11y3jo9': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '2fmvgn4s': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'bvof9o40': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '8jim4fhk': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'lrl71t4l': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'n6o0ksz9': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    '309rfzse': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'hqo73nyd': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
    'zp8crh45': {
      'en': '',
      'hi': '',
      'mr': '',
      'ta': '',
    },
  },
].reduce((a, b) => a..addAll(b));
