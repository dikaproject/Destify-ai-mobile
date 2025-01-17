import 'package:flutter/material.dart';
import 'package:destify_mobile/utils/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final _destinationController = TextEditingController();
  int _duration = 1;
  int _travelers = 1;
  String _travelStyle = 'standard';
  double _budget = 1000000;
  bool _isLoading = false;
  String? _tripPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      bottom: -50,
                      child: Icon(
                        Icons.calendar_today,
                        size: 200,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('planYourJourney'),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context).translate('createPerfectTrip'),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Destination Input with Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('destination'),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _destinationController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.place,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              hintText: AppLocalizations.of(context).translate('enterDestination'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 16),

                  // Trip Details Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('tripDetails'),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Duration with custom design
                          _buildDetailItem(
                            context,
                            Icons.timer,
                            AppLocalizations.of(context).translate('duration'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => setState(() {
                                    if (_duration > 1) _duration--;
                                  }),
                                ),
                                Text(
                                  '$_duration ${AppLocalizations.of(context).translate('days')}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => setState(() => _duration++),
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 32),

                          // Travelers with custom design
                          _buildDetailItem(
                            context,
                            Icons.people,
                            AppLocalizations.of(context).translate('travelers'),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => setState(() {
                                    if (_travelers > 1) _travelers--;
                                  }),
                                ),
                                Text(
                                  '$_travelers',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => setState(() => _travelers++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 200)),
                  const SizedBox(height: 16),

                  // Budget and Style Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('preferences'),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Budget Slider with better design
                          Text(
                            '${AppLocalizations.of(context).translate('budget')}: Rp ${_budget.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Slider(
                            value: _budget,
                            min: 1000000,
                            max: 50000000,
                            divisions: 49,
                            label: 'Rp ${_budget.toStringAsFixed(0)}',
                            onChanged: (value) => setState(() => _budget = value),
                          ),

                          const Divider(height: 32),

                          // Travel Style with custom design
                          Text(
                            AppLocalizations.of(context).translate('travelStyle'),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStyleOption(
                                  'budget',
                                  Icons.savings,
                                  AppLocalizations.of(context).translate('budget'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStyleOption(
                                  'standard',
                                  Icons.star_outline,
                                  AppLocalizations.of(context).translate('standard'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStyleOption(
                                  'luxury',
                                  Icons.diamond_outlined,
                                  AppLocalizations.of(context).translate('luxury'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 400)),
                  const SizedBox(height: 24),

                  // Generate Plan Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _generatePlan,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(AppLocalizations.of(context).translate('generatePlan')),
                    ),
                  ).animate().fadeIn().slideX(delay: const Duration(milliseconds: 600)),

                  if (_tripPlan != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context).translate('tripPlanTitle'),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(_tripPlan!),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideX(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    Widget content,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStyleOption(String value, IconData icon, String label) {
    final isSelected = _travelStyle == value;
    return GestureDetector(
      onTap: () => setState(() => _travelStyle = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : null,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePlan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _tripPlan = 'Sample AI generated trip plan...';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
}
