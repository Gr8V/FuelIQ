import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/secondary/onboarding_page.dart';
import 'package:fuel_iq/services/notification_service.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/main.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _loadingStatus = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeApp();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      if (!mounted) return;

      // 2. Load saved foods
      _updateStatus('Loading saved foods...', 0.4);
      final savedFoodsProvider = context.read<SavedFoodsProvider>();
      await savedFoodsProvider.loadSavedFoods();
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // 3. Initialize daily data
      _updateStatus('Loading your data...', 0.6);
      final dataProvider = context.read<DailyDataProvider>();
      await dataProvider.initialize();
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // 4. Initialize notifications
      _updateStatus('Setting up notifications...', 0.8);
      await NotificationService.init();
      await NotificationService.requestPermission();
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // 5. Check onboarding status
      _updateStatus('Almost ready...', 0.9);
      final hasCompletedOnboarding = await OnboardingService.hasCompletedOnboarding();
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // 6. Navigate to appropriate screen
      _updateStatus('Done!', 1.0);
      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => hasCompletedOnboarding 
              ? const HomeScreen() 
              : const OnboardingPage(),
        ),
      );
    } catch (e) {
      // Handle initialization errors
      if (!mounted) return;
      
      _updateStatus('Error loading app', 0.0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _progress = 0.0;
                _loadingStatus = 'Initializing...';
              });
              _initializeApp();
            },
          ),
        ),
      );
    }
  }

  void _updateStatus(String status, double progress) {
    if (mounted) {
      setState(() {
        _loadingStatus = status;
        _progress = progress;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo/icon
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            Icons.local_fire_department,
                            size: 100,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // App name
                    Text(
                      'FuelIQ',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Tagline
                    Text(
                      'Track Your Nutrition',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Progress indicator
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Loading status text
                          Text(
                            _loadingStatus,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Version or additional info (optional)
                    Text(
                      'v1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}