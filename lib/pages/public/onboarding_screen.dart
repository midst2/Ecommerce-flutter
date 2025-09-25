import 'dart:math' as math;
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final pages = <_OBPageData>[
    _OBPageData(
      title: "DISCOVER",
      subtitle: "Fresh drops, classics, and collabs — all in one place.",
      asset: "assets/onboard/onboard1.png", // e.g. a clean PNG of a Nike shoe
      bgTop: const Color(0xFF0E0E0E),
      bgBottom: const Color(0xFF1B1B1B),
      accent: Colors.white,
    ),
    _OBPageData(
      title: "EXCLUSIVE DROPS",
      subtitle: "Members-only early access. Don’t miss heat again.",
      asset: "assets/onboard/onboard2.png",
      bgTop: const Color(0xFF0E0E0E),
      bgBottom: const Color(0xFF141414),
      accent: Colors.white,
    ),
    _OBPageData(
      title: "FAST CHECKOUT",
      subtitle: "One-tap pay, tracked shipping, easy returns.",
      asset: "assets/onboard/onboard3.png",
      bgTop: const Color(0xFF0D0D0D),
      bgBottom: const Color(0xFF0A0A0A),
      accent: Colors.white,
    ),
  ];

  void _next() {
    if (_index < pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _skip() {
    _controller.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PAGES
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) => _NikeSlide(data: pages[i]),
            ),

            // TOP BAR
            Positioned(
              left: 16,
              right: 16,
              top: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Faux “swoosh stripe” accent
                  Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: const Text("KICKS", style: TextStyle(letterSpacing: 2, color: Colors.white70, fontWeight: FontWeight.w700)),
                  ),
                  if (!isLast)
                    TextButton(
                      onPressed: _skip,
                      child: const Text("Skip", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),

            // INDICATORS
            Positioned(
              left: 0,
              right: 0,
              bottom: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 6,
                    width: i == _index ? 28 : 10,
                    decoration: BoxDecoration(
                      color: i == _index ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),

            // CTA
            Positioned(
              left: 24,
              right: 24,
              bottom: 6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _next,
                child: Text(isLast ? "Get Started" : "Next",
                    style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OBPageData {
  final String title;
  final String subtitle;
  final String asset;
  final Color bgTop;
  final Color bgBottom;
  final Color accent;

  _OBPageData({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.bgTop,
    required this.bgBottom,
    required this.accent,
  });
}

class _NikeSlide extends StatelessWidget {
  const _NikeSlide({required this.data});
  final _OBPageData data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.bgTop, data.bgBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // big vertical wordmark vibe
          Positioned(
            top: size.height * 0.1,
            left: -8,
            child: Opacity(
              opacity: 0.05,
              child: Text(
                "NIKE",
                style: TextStyle(
                  fontSize: size.width * 0.35,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // shoe card
          Align(
            alignment: Alignment(0, -0.05),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 560),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                    color: Colors.black.withOpacity(0.35),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // subtle gray pattern bg
                      Container(color: const Color(0xFFF4F4F4)),
                      // the shoe (slight tilt)
                      Center(
                        child: Transform.rotate(
                          angle: -6 * math.pi / 180,
                          child: Image.asset(
                            data.asset,
                            fit: BoxFit.contain,
                        
                          ),
                        ),
                      ),
                      // corner label
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text("NEW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // copy
          Align(
            alignment: const Alignment(0, 0.75),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 15.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
