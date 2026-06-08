import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GenreBrowsingScreen(),
  ));
}

// BƯỚC 1: KHỞI TẠO DATA MODEL & DỮ LIỆU MẪU
class Movie {
  final String title;
  final String genre;
  final int year;
  final double rating;
  final String posterUrl;

  Movie({
    required this.title,
    required this.genre,
    required this.year,
    required this.rating,
    required this.posterUrl,
  });
}

// BƯỚC 2: XÂY DỰNG GIAO DIỆN CHÍNH (STATEFUL WIDGET)
class GenreBrowsingScreen extends StatefulWidget {
  const GenreBrowsingScreen({super.key});

  @override
  State<GenreBrowsingScreen> createState() => _GenreBrowsingScreenState();
}

class _GenreBrowsingScreenState extends State<GenreBrowsingScreen> {
  // Dữ liệu tĩnh giả lập
  final List<Movie> _allMovies = [
    Movie(title: 'Dune: Part Two', genre: 'Sci-Fi', year: 2024, rating: 8.8, posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400&q=80'),
    Movie(title: 'Deadpool & Wolverine', genre: 'Action', year: 2024, rating: 8.3, posterUrl: 'https://images.unsplash.com/photo-1569003339405-ea396a5a8a90?w=400&q=80'),
    Movie(title: 'The Dark Knight', genre: 'Action', year: 2008, rating: 9.0, posterUrl: 'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=400&q=80'),
    Movie(title: 'Interstellar', genre: 'Sci-Fi', year: 2014, rating: 8.7, posterUrl: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=400&q=80'),
    Movie(title: 'The Hangover', genre: 'Comedy', year: 2009, rating: 7.7, posterUrl: 'https://images.unsplash.com/photo-1603190287605-e6ade32fa852?w=400&q=80'),
    Movie(title: 'Oppenheimer', genre: 'Drama', year: 2023, rating: 8.6, posterUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=400&q=80'),
  ];

  // Trạng thái (State) cho tính năng lọc và tìm kiếm
  String _searchQuery = '';
  String _selectedGenre = 'All';
  String _sortBy = 'A–Z';

  // Danh sách thể loại và tùy chọn sắp xếp
  final List<String> _genres = ['All', 'Action', 'Sci-Fi', 'Comedy', 'Drama'];
  final List<String> _sortOptions = ['A–Z', 'Z–A', 'Year', 'Rating'];

  @override
  Widget build(BuildContext context) {
    // LAB 6.2: XỬ LÝ LOGIC LỌC (FILTERING) & SẮP XẾP (SORTING)
    List<Movie> filteredMovies = _allMovies.where((movie) {
      // Lọc theo Text (Không phân biệt hoa/thường)
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      // Lọc theo Thể loại (Genre)
      final matchesGenre = _selectedGenre == 'All' || movie.genre == _selectedGenre;
      
      return matchesSearch && matchesGenre;
    }).toList();

    // Sắp xếp danh sách sau khi đã lọc
    if (_sortBy == 'A–Z') {
      filteredMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Z–A') {
      filteredMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortBy == 'Year') {
      filteredMovies.sort((a, b) => b.year.compareTo(a.year)); // Giảm dần theo năm
    } else if (_sortBy == 'Rating') {
      filteredMovies.sort((a, b) => b.rating.compareTo(a.rating)); // Giảm dần theo rating
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Movie', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LAB 6.1 & 6.2: THANH TÌM KIẾM, CHIPS THỂ LOẠI & DROPDOWN SẮP XẾP
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search movie by title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _genres.map((genre) {
                return ChoiceChip(
                  label: Text(genre),
                  selected: _selectedGenre == genre,
                  selectedColor: Colors.teal.shade200,
                  onSelected: (bool selected) {
                    if (selected) setState(() => _selectedGenre = genre);
                  },
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Results: ${filteredMovies.length} movies', style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Text('Sort by: ', style: TextStyle(color: Colors.grey)),
                    DropdownButton<String>(
                      value: _sortBy,
                      underline: const SizedBox(),
                      items: _sortOptions.map((option) {
                        return DropdownMenuItem(value: option, child: Text(option));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _sortBy = value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          // LAB 6.3: RESPONSIVE ADAPTIVE LAYOUT (BREAKPOINT = 800PX)
          Expanded(
            child: filteredMovies.isEmpty
                ? const Center(child: Text('No movies found matching your criteria.', style: TextStyle(fontSize: 16)))
                // Sử dụng LayoutBuilder để lấy kích thước khung chứa hiện tại
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Nếu chiều rộng màn hình >= 800px (Tablet/Web) -> Dùng GridView 2 cột
                      if (constraints.maxWidth >= 800) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, 
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) => _buildMovieCard(filteredMovies[index]),
                        );
                      } 
                      // Nếu nhỏ hơn (Điện thoại) -> Dùng ListView 1 cột
                      else {
                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredMovies.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _buildMovieCard(filteredMovies[index]),
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          // Ảnh Poster
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            child: Image.network(
              movie.posterUrl,
              width: 80,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Thông tin phim
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${movie.genre} • ${movie.year}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ),
          // Cột điểm đánh giá (Rating)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(movie.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}