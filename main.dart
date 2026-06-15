import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(208, 255, 153, 0),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(208, 255, 153, 0),
          secondary: const Color.fromARGB(190, 255, 153, 0),
        ),
      ),
      home: const NavigationBarExample(),
    );
  }
}

class NavigationBarExample extends StatefulWidget {
  const NavigationBarExample({super.key});

  @override
  State<NavigationBarExample> createState() => _NavigationBarExampleState();
}

class _NavigationBarExampleState extends State<NavigationBarExample> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      const HomePage(),
      const SearchLibraryPage(),
      ChatPage(onNavigateToLibrary: () => _onItemTapped(1)),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              child: Image.asset('assets/icons/home-1.png', width: 22, height: 18, fit: BoxFit.contain),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              child: Image.asset('assets/icons/book.png', width: 24, height: 22, fit: BoxFit.contain),
            ),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 24,
              child: Image.asset('assets/icons/chatbot.png', width: 24, height: 22, fit: BoxFit.contain),
            ),
            label: 'Chat Bot',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// ================== Shared Widgets ==================

Widget _buildHeader(String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
    decoration: const BoxDecoration(
      color: Color(0xFFFF692E),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: Center(
      child: Text(
        title,
        style: GoogleFonts.libreBaskerville(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// ================== MODELS ==================

class RestaurantSummary {
  final String name;
  final String category;
  final String location;
  final String dietaryPref;
  final String priceRange;
  final double avgStar;
  final int reviewCount;
  final double avgSentiment;
  final double score;

  RestaurantSummary({
    required this.name,
    required this.category,
    required this.location,
    required this.dietaryPref,
    required this.priceRange,
    required this.avgStar,
    required this.reviewCount,
    required this.avgSentiment,
    required this.score,
  });

  factory RestaurantSummary.fromMap(Map<String, dynamic> row) {
    return RestaurantSummary(
      name: (row['restaurant_name'] ?? row['restaurant_r'] ?? '').toString().trim(),
      category: (row['category'] ?? '').toString().trim(),
      location: (row['location'] ?? '').toString().trim(),
      dietaryPref: (row['dietary_pref'] ?? row['dietary_preference'] ?? '').toString().trim(),
      priceRange: (row['price_range'] ?? '').toString().trim(),
      avgStar: double.tryParse((row['avg_star'] ?? '0').toString()) ?? 0,
      reviewCount: int.tryParse((row['review_count'] ?? row['review_cour'] ?? '0').toString()) ?? 0,
      avgSentiment: double.tryParse((row['avg_sentiment'] ?? row['avg_sentime'] ?? '0').toString()) ?? 0,
      score: double.tryParse((row['score'] ?? '0').toString()) ?? 0,
    );
  }
}

class RestaurantReview {
  final String restaurantName;
  final String authorName;
  final String reviewDate;
  final int starRating;
  final String rawReview;
  final String cleanedReview;
  final String predictedSentiment;
  final String category;
  final String location;
  final String dietaryPref;
  final String priceRange;
 
  RestaurantReview({
    required this.restaurantName,
    required this.authorName,
    required this.reviewDate,
    required this.starRating,
    required this.rawReview,
    required this.cleanedReview,
    required this.predictedSentiment,
    required this.category,
    required this.location,
    required this.dietaryPref,
    required this.priceRange,
  });

  factory RestaurantReview.fromMap(Map<String, dynamic> row) {
    return RestaurantReview(
      restaurantName: (row['restaurant_name'] ?? row['restaurant_r'] ?? '').toString().trim(),
      authorName: (row['author_name'] ?? '').toString().trim(),
      reviewDate: (row['review_date'] ?? '').toString().trim(),
      starRating: int.tryParse((row['star_rating'] ?? '0').toString()) ?? 0,
      rawReview: (row['raw_review_content'] ?? row['raw_review_'] ?? '').toString().trim(),
      cleanedReview: (row['cleaned_review_content'] ?? row['cleaned_rev'] ?? '').toString().trim(),
      predictedSentiment: (row['predicted_sentiment'] ?? '').toString().trim(),
      category: (row['category'] ?? '').toString().trim(),
      location: (row['location'] ?? '').toString().trim(),
      dietaryPref: (row['dietary_pref'] ?? row['dietary_preference'] ?? '').toString().trim(),
      priceRange: (row['price_range'] ?? '').toString().trim(),
    );
  }
} 


// ================== CSV HELPERS ==================

Future<List<Map<String, dynamic>>> loadCsvAsMaps(String assetPath) async {
  final rawData = await rootBundle.loadString(assetPath);
  final rows = const CsvToListConverter(eol: '\n').convert(rawData);

  if (rows.isEmpty) return [];

  final headers = rows.first.map((e) => e.toString().trim()).toList();
  final List<Map<String, dynamic>> result = [];

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.isEmpty) continue;

    final map = <String, dynamic>{};
    for (int j = 0; j < headers.length; j++) {
      map[headers[j]] = j < row.length ? row[j] : '';
    }
    result.add(map);
  }

  return result;
}

// ================== IMAGE HELPERS ==================   // 
const Map<String, String> restaurantImageFolders = {
  "A'Decade": "adecade",
  "Aftermeal Desserts": "aftermeal",
  "Bamboo House Korean BBQ Restaurant": "bamboo",
  "Bar.B.Q Plaza": "barbq",
  "Boards & Brews • by TD": "boards_brews",
  "Ăn Viet": "an_viet",
  "Châteraisé": "chateraise",
  "Dunkin' Donuts": "dunkin",
  "Giraffe Café & Restaurant": "giraffe",
  "Labu + Labu": "labu",
  "Madam Kwan's": "madam_kwan",
  "Mantra Indian Cuisine印度餐": "mantra",
  "McDonald's": "mcdonalds",
  "Mr. Dakgalbi": "dakgalbi",
  "Mr. Tuk Tuk": "tuk_tuk",
  "PAUL LE CAFÉ": "paul",
  "Restoran Fong Kee 豐記燒臘粥面飯店": "fong_kee",
  "Sister's food": "sisters",
  "talker Coffee & Chocolate": "talker",
  "Vegetarian stall @ Rock Cafe": "vege_rock_cafe",
  "Yamaguchi Fish Market 海鲜餐厅": "yamaguchi",
  "探鱼烤鱼 • TANYU": "tanyu",
  "第十七层": "17th_floor",
  "蜀味轩 SHU WEI XUAN": "shu_wei_xuan",
  "Beyond Coffee": "beyond_coffee",
  "Black Tap": "black_tap",
  "Bungkus Kaw Kaw": "bungkus_kaw_kaw",
  "Burger Baek Sunway": "burger_baek_sunway", 
  "Burger King": "burger_king",
  "Cafe Roffle": "cafe_roffle",
  "Caffeinees": "caffeinees",
  "Chicken Soup Master": "chicken_soup_master",
  "Chilis": "chilis",
  "Cili Kampung": "cili_kampung",
  "Classic Food Street": "classic_food_street",
  "DC Coffee": "dc_coffee",
  "Donkas Lab": "donkas_lab",
  "Fat Cat": "fat_cat",
  "Fat One BBQ Steamboat": "fat_one_bbq_steamboat",
  "Flower Girl Coffee": "flower_girl_coffee",
  "Fluffed Cafe": "fluffed",
  "Food City": "food_city",
  "Forever Green Restaurant": "forever_green",
  "Four Beans": "four_beans",
  "Garage 51": "garage_51",
  "Genki Sushi": "genki_sushi",
  "Han Bun Sik": "han_bun_sik",
  "Hana Dining Sake Bar": "hana_dining_sake_bar",
  "Ik Prestige Cafe": "ik_prestige_cafe",
  "Inside Scoop": "inside_scoop",
  "Kean Seng Kopitiam": "kean_seng_kopitiam",
  "Kooky Bowl": "kooky_bowl",
  "Kopitiam Yang Yang": "kopitiam_yang_yang",
  "Lala Chong Seafood Restaurant": "lala_chong_seafood_restaurant",
  "Maisen": "maisen",
  "Maria's Steak Cafe": "maria_steak_cafe",
  "Nasi Kandar Anwar Maju": "anwar_maju",
  "New Ming Tien Restaurant": "new_ming_tien",
  "Oriental Kopi": "oriental_kopi",
  "Palsaik Korean BBQ": "palsaik",
  "Papasan Canteen": "papasan",
  "Poison Apple": "poison_apple",
  "Pommes Frites Malaysia": "pommes_frites",
  "ROCKU Yakiniku": "rocku_yakiniku",
  "Raiz Dining": "raiz_dining",
  "Restaurant Thai Boss Charcoal Mookata": "thai_boss",
  "Restoran 28": "restoran_28",
  "Restoran Jaring Malay Restaurant": "jaring_malay",
  "Restoran Lai Kong": "restoran_lai_kong",
  "Restoran Nam Yiang": "restoran_nam_yiang",
  "Restoran Nasi Kandar Shaaz": "shaaz",
  "Restoran Sri Bidara": "restoran_sri_bidara",
  "Rock Cafe": "rock_cafe",
  "SUWON BBQ and POCHA Korean Restaurant": "suwon",
  "Shiang Hai": "shiang_hai",
  "Simple Life": "simple_life",
  "Sips Coffee": "sips_coffee",
  "Snoplus Dessert Cafe": "snoplus",
  "Souper Tang": "souper_tang",
  "Sparkora BBQ Malaysia": "sparkora",
  "Subway": "subway",
  "Sweet Gather": "sweet_gather",
  "TGI Fridays": "tgi_fridays",
  "Taco Bell": "taco_bell",
  "Texas Chicken": "texas_chicken",
  "The Brew House": "the_brew_house",
  "The Mad Alchemy": "the_mad_alchemy",
  "The Owls Cafe": "the_owls_cafe",
  "Thyme Out HQ": "thyme_out_hq",
  "Traffic Bean": "traffic_bean",
  "Ummi Corner": "ummi_corner",
  "VeryThai": "verythai",
  "Village Roast Duck": "village_roast_duck",
  "Washoku Japanese Restaurant": "washoku",
  "Yakiniku Kuro": "yakiniku_kuro",
  "Yeast": "yeast",
  "Zen House": "zen_house",
  "Zhia Kitchen": "zhia_kitchen",
  "dipndip Chocolate cafe": "dipndip",
  "iTOR": "itor",
};

String getRestaurantFolderName(String restaurantName) {
  return restaurantImageFolders[restaurantName] ??
      restaurantName
          .toLowerCase()
          .replaceAll('&', 'and')
          .replaceAll("'", '')
          .replaceAll('/', '_')
          .replaceAll('-', '_')
          .replaceAll(' ', '_')
          .replaceAll(RegExp(r'[^a-z0-9_]'), '');
}

String getRestaurantCoverImage(String restaurantName) {
  final folder = getRestaurantFolderName(restaurantName);
  return 'assets/image/restaurant/$folder/cover.jpg';
}

List<String> getRestaurantGalleryImages(String restaurantName) {
  final folder = getRestaurantFolderName(restaurantName);
  return List.generate(
    5,
    (index) => 'assets/image/restaurant/$folder/${index + 1}.jpg',
  );
}

// ================== Home Page ==================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( 
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Image.asset(
              'assets/icons/Sunbites.png',
              fit: BoxFit.contain,
              width: 250, 
              height: 180,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sunbites',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF692E),
                letterSpacing: 2,
                fontFamily: 'Microsoft JhengHei',
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Discover the best local eats around you',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3A4A),
                  fontFamily: 'Microsoft JhengHei',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== Search / Library Page ==================
class SearchLibraryPage extends StatefulWidget {
  const SearchLibraryPage({super.key});

  @override
  State<SearchLibraryPage> createState() => _SearchLibraryPageState();
}

class _SearchLibraryPageState extends State<SearchLibraryPage> {
  List<RestaurantSummary> allRestaurants = [];
  List<RestaurantSummary> filteredRestaurants = [];
  List<RestaurantReview> allReviews = [];

  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';
  String selectedPriceRange = 'All';
  String selectedDietaryPref = 'All';
  String selectedLocation = 'All';
  double selectedMinStar = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _warmUpServer();
    loadData();
    searchController.addListener(applyFilters);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _warmUpServer() async {
  try {
    await http.get(Uri.parse('https://fyp-sunbites.onrender.com/'));
  } catch (_) {}
}

  Future<void> loadData() async {
    try {
      final summaryMaps = await loadCsvAsMaps('assets/data/restaurant_summary.csv');
      final reviewMaps = await loadCsvAsMaps('assets/data/cleaned_testing_final_dataset.csv');

      allRestaurants = summaryMaps.map((e) => RestaurantSummary.fromMap(e)).toList();
      allReviews = reviewMaps.map((e) => RestaurantReview.fromMap(e)).toList();

      filteredRestaurants = List.from(allRestaurants);
    } catch (e) {
      debugPrint('Error loading CSV: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      filteredRestaurants = allRestaurants.where((restaurant) {
        final matchesSearch = restaurant.name.toLowerCase().contains(query);

        final matchesCategory =
            selectedCategory == 'All' || restaurant.category == selectedCategory;

        final matchesPrice =
            selectedPriceRange == 'All' || restaurant.priceRange == selectedPriceRange;

        final matchesDietary =
            selectedDietaryPref == 'All' || restaurant.dietaryPref == selectedDietaryPref;

        final matchesLocation =
            selectedLocation == 'All' || restaurant.location == selectedLocation;

        final matchesStar = restaurant.avgStar >= selectedMinStar;

        return matchesSearch &&
            matchesCategory &&
            matchesPrice &&
            matchesDietary &&
            matchesLocation &&
            matchesStar;
      }).toList();
    });
  }

  List<String> getUniqueValues(List<String> values) {
    final unique = values.toSet().toList();
    unique.sort();
    return ['All', ...unique];
  }

  @override
  Widget build(BuildContext context) {
    final categories = getUniqueValues(allRestaurants.map((e) => e.category).toList());
    final priceRanges = getUniqueValues(allRestaurants.map((e) => e.priceRange).toList());
    final dietaryPrefs = getUniqueValues(allRestaurants.map((e) => e.dietaryPref).toList());
    final locations = getUniqueValues(allRestaurants.map((e) => e.location).toList());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader("Search & Library"),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search restaurant...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    "Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    _buildDropdown(
                      label: 'Category',
                      value: selectedCategory,
                      items: categories,
                      onChanged: (value) {
                        selectedCategory = value!;
                        applyFilters();
                      },
                    ),
                    _buildDropdown(
                      label: 'Budget Range',
                      value: selectedPriceRange,
                      items: priceRanges,
                      onChanged: (value) {
                        selectedPriceRange = value!;
                        applyFilters();
                      },
                    ),
                    _buildDropdown(
                      label: 'Dietary Preference',
                      value: selectedDietaryPref,
                      items: dietaryPrefs,
                      onChanged: (value) {
                        selectedDietaryPref = value!;
                        applyFilters();
                      },
                    ),
                    _buildDropdown(
                      label: 'Location',
                      value: selectedLocation,
                      items: locations,
                      onChanged: (value) {
                        selectedLocation = value!;
                        applyFilters();
                      },
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Minimum Star Rating: ${selectedMinStar.toStringAsFixed(1)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Slider(
                      value: selectedMinStar,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: selectedMinStar.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          selectedMinStar = value;
                        });
                        applyFilters();
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${filteredRestaurants.length} restaurants found",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: filteredRestaurants.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final restaurant = filteredRestaurants[index];

                  return GestureDetector(
                    onTap: () {
                      final reviews = allReviews
                          .where((r) =>
                              r.restaurantName.trim().toLowerCase() ==
                              restaurant.name.trim().toLowerCase())
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailPage(
                            restaurant: restaurant,
                            reviews: reviews,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                getRestaurantCoverImage(restaurant.name),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.restaurant, color: Colors.grey),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("${restaurant.category} • ${restaurant.location}"),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildTag(restaurant.priceRange),
                                      if (restaurant.dietaryPref.isNotEmpty)
                                        _buildTag(restaurant.dietaryPref),
                                      _buildTag("⭐ ${restaurant.avgStar.toStringAsFixed(1)}"),
                                      _buildTag("${restaurant.reviewCount} reviews"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF4B5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ================== Chat Page ==================
class ChatPage extends StatefulWidget {
  final VoidCallback onNavigateToLibrary;
  const ChatPage({super.key, required this.onNavigateToLibrary});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Widget> _chatMessages = [];
  int _currentStep = 0;
  bool _showResults = false;
  final Map<String, String> _selections = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startFlow() {
    setState(() {
      _showResults = false;
      _chatMessages.clear();
      _chatMessages.add(_buildAiMessage(
          "Hello! I’m your Chatbot assistant, here to help you find the perfect place to dine."));
      _chatMessages.add(const SizedBox(height: 8));
      _chatMessages.add(_buildAiMessage(
          "Please answer a few quick questions so I can better understand your preferences."));
    });
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _askQuestion(1, "What type of cuisine do you prefer?");
    });
  }

  void _askQuestion(int step, String text) {
    setState(() {
      _currentStep = step;
      _chatMessages.add(const SizedBox(height: 20));
      _chatMessages.add(_buildAiMessage(text));
    });
    _scrollToBottom();
  }

  void _handleSelection(String category, String value, int nextStep, String nextQuestion) {
    setState(() {
      _selections[category] = value;
      _chatMessages.add(const SizedBox(height: 20));
      _chatMessages.add(_buildUserMessage(value));
      _currentStep = 99;
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        if (nextStep <= 5) {
          _askQuestion(nextStep, nextQuestion);
        } else {
          setState(() => _currentStep = 6);
          _scrollToBottom();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return ResultsView(
        preferences: _selections,
        // onBack callback removed here
        onExploreLibrary: widget.onNavigateToLibrary,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader("Chatbot"),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ..._chatMessages,
                    const SizedBox(height: 20),
                    if (_currentStep == 1)
                      _buildOptionsGrid([
                        "Asian", "Cafe", "Dessert", "Fast Food", "Fine Dining/Fusion/Special Occasion",
                        "Hawker/Food Court", "Malaysian Restaurant", "Seafood/BBQ", "Vegetarian",
                        "Western/European"
                      ], "cuisine", 2, "What is your preferred restaurant rating?"),
                    if (_currentStep == 2)
                      _buildOptionsGrid(["1", "2", "3", "4", "5", "No Preference"],
                          "rating", 3, "Which location do you prefer?"),
                    if (_currentStep == 3)
                      _buildOptionsGrid([
                        "Nadayu 28 Dagang Hostel", "Rock Cafe", "Sunway College", "Sunway Geo Avenue",
                        "Sunway Industrial Park", "Sunway Medical Centre", "Sunway Mentari",
                        "Sunway Pyramid", "Sunway University", "The Pinnacle Sunway", "No Preference"
                      ], "location", 4, "Do you have any dietary preference?"),
                    if (_currentStep == 4)
                      _buildOptionsGrid(["Muslim-friendly", "Vegetarian", "None"],
                          "dietary", 5, "What is your preferred budget range per person?"),
                    if (_currentStep == 5)
                      _buildOptionsGrid([
                        "Under RM20", "RM20-40", "RM40-80", "RM80+", "No Preference"
                      ], "budget", 6, ""),
                    if (_currentStep == 6) _buildResultsArrow(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsArrow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Results",
          style: GoogleFonts.libreBaskerville(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => setState(() => _showResults = true),
          child: const CircleAvatar(
            backgroundColor: Color(0xFFFF692E),
            radius: 20,
            child: Icon(Icons.arrow_forward, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildAiMessage(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chatbot Assistant",
          style: GoogleFonts.libreBaskerville(color: const Color(0xFFFF692E), fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
          child: Text(text, style: GoogleFonts.libreBaskerville(fontSize: 15, color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildUserMessage(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "User",
          style: GoogleFonts.libreBaskerville(color: const Color(0xFFFF692E), fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
          child: Text(text, style: GoogleFonts.libreBaskerville(fontSize: 15, color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildOptionsGrid(List<String> options, String category, int next, String nextQ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((label) => _buildOptionButton(label, category, next, nextQ)).toList(),
    );
  }

  Widget _buildOptionButton(String label, String category, int next, String nextQ) {
    return GestureDetector(
      onTap: () => _handleSelection(category, label, next, nextQ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF4B5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Text(
          label,
          style: GoogleFonts.libreBaskerville(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}

// ================== RESTAURANT DETAIL PAGE ==================

class RestaurantDetailPage extends StatelessWidget {
  final RestaurantSummary restaurant;
  final List<RestaurantReview> reviews;

  const RestaurantDetailPage({
    super.key,
    required this.restaurant,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final galleryImages = getRestaurantGalleryImages(restaurant.name);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(restaurant.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("${restaurant.category} • ${restaurant.location}"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _detailChip("Price", restaurant.priceRange),
                _detailChip("Dietary", restaurant.dietaryPref),
                _detailChip("Avg Star", restaurant.avgStar.toStringAsFixed(2)),
                _detailChip("Avg Sentiment", restaurant.avgSentiment.toStringAsFixed(2)),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              "Photos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: galleryImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      galleryImages[index],
                      width: 160,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 160,
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Reviews",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (reviews.isEmpty)
              const Text("No reviews available.")
            else
              ...reviews.map(
                (review) => Card(
                  color: const Color(0xFFF9F9F9),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.authorName.isEmpty ? "Anonymous" : review.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text("⭐ ${review.starRating} • ${review.reviewDate}"),
                        const SizedBox(height: 8),
                        Text(review.rawReview),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final sentiment = review.predictedSentiment.toLowerCase();
                            final displaySentiment =
                                sentiment[0].toUpperCase() + sentiment.substring(1);

                            return Text(
                              "Sentiment: $displaySentiment",
                              style: TextStyle(
                                color: sentiment == 'positive'
                                    ? Colors.green
                                    : sentiment == 'negative'
                                        ? Colors.red
                                        : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailChip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF4B5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ================== Results View (Internal) ==================
class ResultsView extends StatefulWidget {
  final Map<String, String> preferences;
  // onBack removed from constructor
  final VoidCallback onExploreLibrary;

  const ResultsView({super.key, required this.preferences, required this.onExploreLibrary});

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  List<dynamic> restaurants = [];
  bool isLoading = true;
  String errorMessage = '';

  List<RestaurantReview> allReviews = [];
  bool isReviewsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadReviews();
    fetchRecommendations();
  }

  Future<void> loadReviews() async {
  try {
    final reviewMaps =
        await loadCsvAsMaps('assets/data/cleaned_testing_final_dataset.csv');
    allReviews = reviewMaps.map((e) => RestaurantReview.fromMap(e)).toList();
  } catch (e) {
    debugPrint("Error loading reviews: $e");
  }

  if (mounted) {
    setState(() {
      isReviewsLoaded = true;
    });
  }
  }

  RestaurantSummary mapApiResultToRestaurantSummary(Map<String, dynamic> item) {
  return RestaurantSummary(
    name: (item['restaurant_name'] ?? '').toString(),
    category: (item['category'] ?? '').toString(),
    location: (item['location'] ?? '').toString(),
    dietaryPref: (item['dietary_pref'] ?? item['dietary_preference'] ?? '').toString(),
    priceRange: (item['price_range'] ?? '').toString(),
    avgStar: double.tryParse((item['avg_star'] ?? '0').toString()) ?? 0,
    reviewCount: int.tryParse((item['review_count'] ?? item['review_cour'] ?? '0').toString()) ?? 0,
    avgSentiment: double.tryParse((item['avg_sentiment'] ?? '0').toString()) ?? 0,
    score: double.tryParse((item['score'] ?? '0').toString()) ?? 0,
  );
  }

  String _cleanPreference(String key, String? value) {
    if (value == null || value == "No Preference") return "";
    if (key == "dietary" && value == "None") return "None";
    return value;
  }

  Future<void> fetchRecommendations() async {
    double minStar = double.tryParse(widget.preferences['rating'] ?? '0') ?? 0.0;
    final Map<String, dynamic> payload = {
      "category": _cleanPreference("cuisine", widget.preferences['cuisine']),
      "location": _cleanPreference("location", widget.preferences['location']),
      "min_star": minStar,
      "dietary": _cleanPreference("dietary", widget.preferences['dietary']),
      "budget": _cleanPreference("budget", widget.preferences['budget']),
      "top_k": 5,
    };

    try {
      final response = await http.post(
        Uri.parse('https://fyp-sunbites.onrender.com/recommend'), //modified
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
        );

      if (response.statusCode == 200) {
        String cleanedBody = response.body.replaceAll(': NaN', ': null');
        final data = jsonDecode(cleanedBody);
        if (mounted) setState(() { restaurants = data['recommendations'] ?? []; isLoading = false; });
      } else {
        if (mounted) setState(() { errorMessage = "Server error: ${response.statusCode}"; isLoading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { errorMessage = "App Error: $e"; isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader("SunBites Picks"),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFFCF4B5), borderRadius: BorderRadius.circular(24)),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF692E)))
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : restaurants.isEmpty
                          ? const Center(child: Text("No restaurants found matching your criteria."))
                          : ListView.builder(
                              itemCount: restaurants.length,
                              itemBuilder: (context, index) {
                                final item = restaurants[index] as Map<String, dynamic>;
                                final restaurant = mapApiResultToRestaurantSummary(item);

                                return GestureDetector(
                                  onTap: () {
                                    final matchedReviews = allReviews.where((r) =>
                                        r.restaurantName.trim().toLowerCase() ==
                                        restaurant.name.trim().toLowerCase()).toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RestaurantDetailPage(
                                          restaurant: restaurant,
                                          reviews: matchedReviews,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.asset(
                                              getRestaurantCoverImage(restaurant.name),
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 90,
                                                  height: 90,
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(Icons.restaurant, color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  restaurant.name,
                                                  style: const TextStyle(
                                                    color: Color(0xFFFF692E),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text("${restaurant.category} • ${restaurant.location}"),
                                                const SizedBox(height: 8),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _buildTag(restaurant.priceRange),
                                                    if (restaurant.dietaryPref.isNotEmpty)
                                                      _buildTag(restaurant.dietaryPref),
                                                    _buildTag("⭐ ${restaurant.avgStar.toStringAsFixed(1)}"),
                                                    _buildTag("${restaurant.reviewCount} reviews"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: widget.onExploreLibrary,
              icon: const Icon(Icons.library_books, color: Color(0xFFFF692E)),
              label: const Text("Explore Full Library", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3A4A))),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFFF692E), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
            ),
          ),
          // "Back to Chat" TextButton has been removed here
          const SizedBox(height: 20), // Added spacing for aesthetics
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFFCF4B5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
} 
}