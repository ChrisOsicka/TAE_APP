import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart'; // ← para usar kIsWeb
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ActivityDetailScreen extends StatefulWidget {
  final String activityName;
  final List<String> exercises;

  const ActivityDetailScreen({
    Key? key,
    required this.activityName,
    required this.exercises,
  }) : super(key: key);

  @override
  State<ActivityDetailScreen> createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  late List<String> _exercises;
  final Map<int, List<Map<String, dynamic>>> _mediaPerExercise = {};

  @override
  void initState() {
    super.initState();
    _exercises = List<String>.from(widget.exercises);
  }

  //  Agregar ejercicio
  void _addExercise() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        title: const Text('Agregar ejercicio'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre del ejercicio',            
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _exercises.add(controller.text.trim());
                });
              }
              Navigator.pop(ctx);
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 156, 196) ,
                foregroundColor: const Color.fromARGB(251, 248, 248, 248),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            child: const Text('Guardar'),

          ),
        ],
      ),
    );
  }

  //  Editar ejercicio
  void _editExercise(int index) async {
    final controller = TextEditingController(text: _exercises[index]);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        title: const Text('Editar ejercicio'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nuevo nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _exercises[index] = controller.text.trim();
                });
              }
              Navigator.pop(ctx);
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 156, 196) ,
                foregroundColor: const Color.fromARGB(251, 248, 248, 248),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  //  Eliminar ejercicio con confirmación
  void _deleteExercise(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Seguro que quieres eliminar este ejercicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _exercises.removeAt(index);
                _mediaPerExercise.remove(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  //  Agregar imagen o video
  Future<void> _addMedia(int index) async {
    final picker = ImagePicker();

    await showModalBottomSheet(
      backgroundColor: Color.fromARGB(251, 248, 248, 248),
                  
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('Agregar imagen'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  final bytes = await picked.readAsBytes();
                  setState(() {
                    _mediaPerExercise.putIfAbsent(index, () => []).add({
                      'type': 'image',
                      'bytes': bytes,
                    });
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.red),
              title: const Text('Agregar video'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await picker.pickVideo(source: ImageSource.gallery);
                if (picked != null) {
                  final bytes = await picked.readAsBytes();
                  setState(() {
                    _mediaPerExercise.putIfAbsent(index, () => []).add({
                      'type': 'video',
                      'bytes': bytes,
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  //  Eliminar media
  void _deleteMedia(int exerciseIndex, int mediaIndex) {
    setState(() {
      _mediaPerExercise[exerciseIndex]?.removeAt(mediaIndex);
    });
  }

  // Ver en grande (imagen o video)
  void _viewMedia(Map<String, dynamic> mediaItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        if (mediaItem['type'] == 'image') {
          return Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.pop(ctx),
              child: InteractiveViewer(
                child: Image.memory(
                  mediaItem['bytes'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        } else {
          return Dialog(
            backgroundColor: Colors.black,
            insetPadding: const EdgeInsets.all(10),
            child: VideoViewer(videoBytes: mediaItem['bytes']),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.activityName),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        backgroundColor: const Color.fromARGB(255, 3, 84, 150),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar ejercicio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ejercicios',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_exercises.isEmpty)
              const Text('No hay ejercicios aún.', style: TextStyle(color: Colors.grey))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _exercises.length,
                itemBuilder: (context, index) {
                  final exercise = _exercises[index];
                  final media = _mediaPerExercise[index] ?? [];

                  return Card(
                    
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            
                            leading: const Icon(Icons.fitness_center),
                            title: Text(exercise),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') _editExercise(index);
                                if (value == 'delete') _deleteExercise(index);
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(                        
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Eliminar'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Contenido multimedia:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                                onPressed: () => _addMedia(index),
                              ),
                            ],
                          ),
                          if (media.isEmpty)
                            const Text('Sin contenido aún.', style: TextStyle(color: Colors.grey))
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: media.length,
                              itemBuilder: (context, mIndex) {
                                final item = media[mIndex];
                                final isVideo = item['type'] == 'video';
                                return GestureDetector(
                                  onTap: () => _viewMedia(item),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: isVideo
                                            ? Container(
                                                color: Colors.black26,
                                                child: const Center(
                                                  child: Icon(Icons.play_circle_fill,
                                                      color: Colors.redAccent, size: 40),
                                                ),
                                              )
                                            : Image.memory(item['bytes'],
                                                fit: BoxFit.cover, width: double.infinity),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _deleteMedia(index, mIndex),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(Icons.close,
                                                color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

//  Widget para reproducir video dentro del modal
class VideoViewer extends StatefulWidget {
  final Uint8List videoBytes;
  const VideoViewer({required this.videoBytes});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController? _controller;

  @override
void initState() {
  super.initState();
  final videoBytes = widget.videoBytes;

  if (kIsWeb) {
    // Web: se puede usar base64 en network
    final videoUrl = Uri.dataFromBytes(
      videoBytes,
      mimeType: 'video/mp4',
    ).toString();

    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  } else {
    // Móvil / Desktop: escribir bytes en archivo temporal
    _loadVideoFile(videoBytes);
  }
}

Future<void> _loadVideoFile(Uint8List bytes) async {
  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/temp_video.mp4');
  await tempFile.writeAsBytes(bytes);
  _controller = VideoPlayerController.file(tempFile)
    ..initialize().then((_) {
      setState(() {});
      _controller!.play();
    });
}


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: _controller != null && _controller!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
