import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MovieHomeScreen(),
  ));
}
//KHỞI TẠO DATA MODEL & DỮ LIỆU MẪU
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// Dữ liệu mẫu (Static Sample Data) để hiển thị
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Dune: Part Two',
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&q=80',
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.8,
    trailers: ['Official Trailer 1', 'Main Trailer', 'Behind the Scenes'],
  ),
  Movie(
    id: 2,
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://images.unsplash.com/photo-1569003339405-ea396a5a8a90?w=600&q=80',
    overview: 'A listless Wade Wilson toils in civilian life until a catastrophic threat forces him to suit up again and team up with a reluctant Wolverine.',
    genres: ['Action', 'Comedy', 'Sci-Fi'],
    rating: 8.3,
    trailers: ['Teaser Trailer', 'Official Trailer', 'Final Trailer'],
  ),
  Movie(
    id: 3,
    title: 'Oppenheimer',
    posterUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=600&q=80',
    overview: 'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.',
    genres: ['Biography', 'Drama', 'History'],
    rating: 8.6,
    trailers: ['Announcement Teaser', 'Main Trailer'],
  )
];


//XÂY DỰNG MÀN HÌNH CHÍNH (HOME SCREEN)
class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: Hero(
                tag: 'movie-poster-${movie.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    movie.posterUrl,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('⭐ ${movie.rating} • ${movie.genres.join(", ")}'),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Điều hướng Navigator.push sang màn hình Detail và truyền object Movie
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// XÂY DỰNG MÀN HÌNH CHI TIẾT (DETAIL SCREEN)
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      // Bọc SingleChildScrollView để màn hình có thể cuộn được
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Nút Back
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            
            // Nội dung chi tiết
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(movie.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  // Genres (Wrap + Chip)
                  Wrap(
                    spacing: 8.0,
                    children: movie.genres.map((g) => Chip(
                      label: Text(g, style: const TextStyle(fontWeight: FontWeight.w500)),
                      backgroundColor: Colors.deepPurple.shade50,
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Overview text
                  const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(movie.overview, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 20),
                  
                  // Hàng IconButtons (Favorite, Rate, Share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, size: 30),
                            color: Colors.red,
                            onPressed: () => setState(() => _isFavorite = !_isFavorite),
                          ),
                          const Text('Favorite')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(icon: const Icon(Icons.star_border, size: 30, color: Colors.amber), onPressed: () {}),
                          const Text('Rate')
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(icon: const Icon(Icons.share, size: 30, color: Colors.blue), onPressed: () {}),
                          const Text('Share')
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Danh sách Trailers
                  const Text('Trailers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true, // Quan trọng: Tránh lỗi tràn layout khi để ListView lồng trong ScrollView
                    physics: const NeverScrollableScrollPhysics(), // Tắt cuộn của ListView con
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 36),
                        title: Text(movie.trailers[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.download, size: 20),
                        contentPadding: EdgeInsets.zero,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}