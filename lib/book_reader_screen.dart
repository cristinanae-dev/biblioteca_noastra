import 'package:flutter/material.dart';
import 'book_data.dart';
import 'chapter_model.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({super.key});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final PageController _pageController = PageController();
  double _fontSize = 18.0; 
  bool _isDarkMode = false; 
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final textColor = _isDarkMode ? const Color(0xFFE0E0E0) : const Color(0xFF212529);
    final appBarColor = _isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 1,
        title: Text(
          "Semizeul - Cap. ${_currentPage + 1}",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(), 
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.format_size, color: textColor),
            onPressed: () {
              setState(() {
                if (_fontSize == 18.0) _fontSize = 22.0;
                else if (_fontSize == 22.0) _fontSize = 26.0;
                else _fontSize = 18.0;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: textColor,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.book, color: textColor),
            onPressed: () => _showChaptersBottomSheet(context),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: semizeulBook.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          // Aici luăm capitolul direct din memoria aplicației tale, nu din fișiere externe!
          final chapter = semizeulBook[index];
          
          return SelectionArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      chapter.title,
                      style: TextStyle(
                        fontSize: _fontSize + 6,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      chapter.subtitle,
                      style: TextStyle(
                        fontSize: _fontSize + 2,
                        fontStyle: FontStyle.italic,
                        color: textColor.withOpacity(0.8),
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(),
                  ),
                  Text(
                    chapter.content,
                    style: TextStyle(
                      fontSize: _fontSize,
                      height: 1.6, 
                      color: textColor,
                      fontFamily: 'Georgia', 
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showChaptersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
      builder: (context) {
        return ListView.builder(
          itemCount: semizeulBook.length,
          itemBuilder: (context, index) {
            final chapter = semizeulBook[index];
            return ListTile(
              title: Text(
                "${chapter.title}: ${chapter.subtitle}",
                style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black70),
              ),
              trailing: _currentPage == index 
                  ? const Icon(Icons.check_circle, color: Colors.green) 
                  : null,
              onTap: () {
                Navigator.pop(context);
                _pageController.jumpToPage(index); 
              },
            );
          },
        );
      },
    );
  }
}