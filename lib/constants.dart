// Firebase App IDs
const String kAppIdiOS = '1:688037325190:ios:27b7368339d68b43';
const String kAppIdAndroid = '1:688037325190:android:67e68583ed1a2d49';

// Microsoft's "Game Content Usage Rules"
const String kGameContentUsageRules = 'Halo Infinite, Halo 5: Guardians, Halo: The Master Chief Collection, Halo 4, Halo 3 © Microsoft Corporation. SWAT Nation was created under Microsoft\'s "Game Content Usage Rules" using assets from Halo Infinite, Halo 5: Guardians, Halo: The Master Chief Collection, Halo 4, Halo 3, and it is not endorsed by or affiliated with Microsoft.';
const String kContentUsageRulesUrl = 'https://www.xbox.com/en-US/developers/rules';

// Keyboard appear/dismiss
const Duration kKeyboardAnimationDuration = Duration(milliseconds: 350);

// Account constants
const int kPasswordMinLength = 6;
const int kDisplayNameMaxChararcters = 15;
const int kMaxBioLength = 140;

// SWAT Nation logo
const String kLogo = 'https://static1.squarespace.com/static/5bfb2111372b964077959077/t/5bfcbd661ae6cf259c75a2ad/1563085290045/?format=500w';

// SWAT Nation social accounts
const String kWebsite = 'https://swatnation.net';
const String kFacebookGroup = 'https://facebook.com/groups/swat-nation';
const String kTwitter = 'https://twitter.com/haloswatnation';
const String kInstagram = 'https://instagram.com/haloswatnation';
const String kXboxClub = 'https://account.xbox.com/en-us/clubs/profile?clubid=3379832045537319';

// Profile
const String kDefaultAvi = 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/assets%2Fprofile.jpg?alt=media&token=da6246b4-cf90-484e-b923-4af3c630722b';
const String kDefaultProfileHeader = 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/assets%2Fprofile_header_background.jpg?alt=media&token=29608a22-932f-444d-843a-c2fa58b4701d';
const String kGamertag = 'https://account.xbox.com/en-us/profile?gamertag=';
const String kVerifiedCopy = 'The blue verified badge on SWAT Nation lets people know that an account of public interest is authentic.';
const String kResetPasswordRequestSent = 'Instructions on how to reset your password have been sent to your account email address.';
const String kEmailAddressForPasswordReset = 'Enter your SWAT Nation account\'s email address.';

// Subscriptions
const String kDefaultSubscribeMessage = 'Subscribe to SWAT Nation Pro to access exclusive benefits:\n\n- Early tourney registration\n- Increase your clips from 3 to 20\n- Earn more ranking points\n- Exclusive profile badge\n- Access exclusive chat rooms\n- No ads\n- More to come 😃';

// Sign In
const String kDefaultSignInMessage = 'SWAT Nation is better enjoyed if you Sign In. Please sign in to register for tourneys, chat, subscribe, and more.\n\nYou can also create an account if needed.';

// Achievements
const String kBecomeLegendTitle = 'Become Legend';
const String kBecomeLegendDescription = 'You\'ve taken your place among the legends of SWAT Nation.';
const String kBecomeLegendBadge = 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/badges%2Fbecome_legend.png?alt=media&token=cf6f903e-cd33-4c04-ab69-2d9858dda41c';
const int kBecomeLegendPoints = 50;
const int kMaxAchievementCards = 5;

// Clips
const String kXboxClipsHost = 'https://xboxclips.com/';
const String kDefaultClipThumbnail = 'https://firebasestorage.googleapis.com/v0/b/swat-nation.appspot.com/o/assets%2Fthumbnail.webp?alt=media&token=d6a53308-b3f2-4146-a371-6b852da0232f';
const int kReseedValue = 100;
const int kMaxRandomValue = 10000;
const Duration kPlayerOverlayFadeAfterDuration = Duration(seconds: 2);
const int kSubClipLimit = 20;
const int kNoSubClipLimit = 3;
const String kSubClipLimitMessage = 'You have reached your clip limit! Please remove older clips to make space for more.';
const String kNoSubClipLimitMessage = 'You have reached your clip limit! Subscribe to SWAT Nation PRO to add up to $kSubClipLimit clips + access to other exlusive benefits.';
const String kNoClipsCopy = 'There are no clips yet.';

// Chat
const int kMaxChatMessages = 200;
const int kMaxMessageCharacters = 140;
const int kAchievementColumnCount = 3;
