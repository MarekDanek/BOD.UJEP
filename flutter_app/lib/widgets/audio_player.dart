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

  // Pamatuje si pozici, když prstem táhneš posuvník (nyní v milisekundách!)
  double? _dragPosition;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    await _audioPlayer.setSource(AssetSource(widget.audioPath.replaceAll('assets/', '')));

    // Řekneme si o celkovou délku natvrdo, ať se odemkne Slider
    final d = await _audioPlayer.getDuration();
    if (d != null && mounted) {
      setState(() => _duration = d);
    }

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
          _dragPosition = null; // Vyčistíme paměť po dohrání
        });
      }
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
    // Čas, který se zrovna ukazuje (změněno na milisekundy pro maximální plynulost)
    final zobrazenyCas = _dragPosition != null
        ? Duration(milliseconds: _dragPosition!.toInt())
        : _position;

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
              // Musíme Column roztáhnout, aby Slider vyplnil místo správně
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    // Vše převedeno na milisekundy = krásně plynulé tažení
                    max: _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1,
                    value: (_dragPosition ?? _position.inMilliseconds.toDouble()).clamp(0, _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1),
                    onChanged: (value) {
                      setState(() => _dragPosition = value);
                    },
                    onChangeEnd: (value) async {
                      await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
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