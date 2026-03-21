import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MiniAudioPlayer extends StatefulWidget {
  final String nazevSkladby;
  final String audioPath;
  final VoidCallback onZavrit;

  const MiniAudioPlayer({
    super.key,
    required this.nazevSkladby,
    required this.audioPath,
    required this.onZavrit,
  });

  @override
  State<MiniAudioPlayer> createState() => _MiniAudioPlayerState();
}

class _MiniAudioPlayerState extends State<MiniAudioPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // NOVÁ PROMĚNNÁ: pamatuje si pozici, když prstem táhneš posuvník
  double? _dragPosition;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    await _audioPlayer.setSource(AssetSource(widget.audioPath.replaceAll('assets/', '')));

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Čas, který se zrovna ukazuje (buď skutečný, nebo ten, kam zrovna táhneš prstem)
    final zobrazenyCas = _dragPosition != null ? Duration(seconds: _dragPosition!.toInt()) : _position;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlayPause,
            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black, size: 28),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: Colors.black,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
                    // TADY JE OPRAVA PŘETÁČENÍ:
                    value: (_dragPosition ?? _position.inSeconds.toDouble()).clamp(0, _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1),
                    onChanged: (value) {
                      // Hýbeme jen vizuálním posuvníkem
                      setState(() => _dragPosition = value);
                    },
                    onChangeEnd: (value) async {
                      // Až když pustíš prst, hudba se reálně přetočí
                      await _audioPlayer.seek(Duration(seconds: value.toInt()));
                      setState(() => _dragPosition = null);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.nazevSkladby,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(zobrazenyCas),
                        style: const TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: widget.onZavrit,
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.close, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}