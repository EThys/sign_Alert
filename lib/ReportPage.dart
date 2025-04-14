import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:record/record.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final Location _locationService = Location();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedLanguage = 'Français';
  String _problemType = 'Nuisance sonore';
  String _urgencyLevel = 'Normal';
  bool _anonymousReport = false;
  File? _selectedImage;
  String _locationText = '';
  LocationData? _currentPosition;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;
  List<File> _selectedImages = [];

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  // Variables pour la lecture audio
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  bool _isPlaying = false;

  // Données pour les menus déroulants
  final List<String> _problemTypes = [
    'Nuisance sonore',
    'Problème de salubrité',
    'Éclairage public défectueux',
    'Route endommagée',
    'Stationnement illégal',
    'Autre problème'
  ];

  final List<String> _urgencyLevels = [
    'Normal',
    'Urgent',
    'Très urgent'
  ];

  // Méthodes pour gérer l'enregistrement audio
  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording.m4a';

        setState(() {
          _isRecording = true;
          _recordDuration = Duration.zero;
        });

        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration += const Duration(seconds: 1);
          });
        });

        await _audioRecorder.start(const RecordConfig(), path: path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
      );
      _stopRecording();
    }
  }

  Future<void> _stopRecording() async {
    _recordTimer?.cancel();
    final path = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
      if (path != null) {
        _audioPath = path;
      }
    });
  }

  Future<void> _deleteRecording() async {
    if (_audioPath != null) {
      final file = File(_audioPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    setState(() {
      _audioPath = null;
      _recordDuration = Duration.zero;
    });
  }


  // Méthode pour jouer/lire l'audio
  Future<void> _playRecording() async {
    if (_audioPath == null) return;

    try {
      setState(() {
        _isPlaying = true;
      });

      await _audioPlayer.play(DeviceFileSource(_audioPath!));

      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        setState(() {
          _playerState = state;
          _isPlaying = state == PlayerState.playing;
        });
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la lecture: $e')),
      );
      setState(() {
        _isPlaying = false;
      });
    }
  }

  // Méthode pour arrêter la lecture
  Future<void> _stopPlaying() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }


  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (images != null && images.isNotEmpty) {
        if (_selectedImages.length + images.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vous ne pouvez sélectionner que 5 images maximum'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection des images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Widget pour la section audio
  Widget _buildAudioRecordingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enregistrement audio (optionnel)',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              if (_audioPath != null)
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.audiotrack, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('Enregistrement (${_recordDuration.inSeconds}s)'),
                        Spacer(),
                        if (!_isPlaying)
                          IconButton(
                            icon: Icon(Icons.play_arrow, color: Colors.green),
                            onPressed: _playRecording,
                          )
                        else
                          IconButton(
                            icon: Icon(Icons.stop, color: Colors.red),
                            onPressed: _stopPlaying,
                          ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: _deleteRecording,
                        ),
                      ],
                    ),
                    if (_isPlaying)
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                  ],
                )
              else if (_isRecording)
                Row(
                  children: [
                    Icon(Icons.mic, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Enregistrement... (${_recordDuration.inSeconds}s)'),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.stop, color: Colors.red),
                      onPressed: _stopRecording,
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(Icons.mic_none, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Aucun enregistrement'),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.mic, color: Colors.green),
                      onPressed: _startRecording,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Images du problème*',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Text('Ajoutez au moins une image (max 5)',
            style: TextStyle(color: Colors.grey)),
        SizedBox(height: 12),
        Container(
          height: 180,
          child: _selectedImages.isEmpty
              ? GestureDetector(
            onTap: _pickImages,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      size: 40, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text('Ajouter des images',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          )
              : GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _selectedImages.length + (_selectedImages.length < 5 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _selectedImages.length) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 30, color: Colors.grey[400]),
                        SizedBox(height: 4),
                        Text('Ajouter',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) throw Exception('Service de localisation désactivé');
      }

      PermissionStatus permission = await _locationService.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _locationService.requestPermission();
        if (permission != PermissionStatus.granted) {
          throw Exception('Permission de localisation refusée');
        }
      }

      final LocationData locationData = await _locationService.getLocation();
      setState(() {
        _currentPosition = locationData;
        _locationText = '${locationData.latitude?.toStringAsFixed(4)}, ${locationData.longitude?.toStringAsFixed(4)}';
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de localisation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void> _submitReport() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   setState(() {
  //     _isSubmitting = true;
  //   });
  //
  //   // Simuler un envoi au serveur
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   setState(() {
  //     _isSubmitting = false;
  //   });
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Signalement envoyé avec succès!'),
  //       backgroundColor: Colors.green[700],
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  //
  //   Navigator.pop(context);
  // }

  // Dans votre méthode _submitReport, ajoutez l'audio aux données envoyées
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    // Créez un objet avec toutes les données du formulaire
    final reportData = {
      'problemType': _problemType,
      'description': _descriptionController.text,
      'address': _addressController.text,
      'location': _locationText,
      'urgency': _urgencyLevel,
      'anonymous': _anonymousReport,
      'images': _selectedImages,
      'audioPath': _audioPath, // Ajoutez le chemin de l'audio
      // ... autres champs ...
    };

    // Simuler un envoi au serveur
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Signalement envoyé avec succès!'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signaler un problème',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFD93E30),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type de problème
              _buildSectionTitle('Type de problème'),
              _buildDropdown(
                value: _problemType,
                items: _problemTypes,
                onChanged: (value) => setState(() => _problemType = value!),
              ),
              const SizedBox(height: 20),
              // Photo
              _buildSectionTitle('Ajouter une photo (optionnel)'),
              _buildImageUploadSection(),
              const SizedBox(height: 20),

              // Localisation
              _buildSectionTitle('Localisation exacte'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Adresse ou point de repère',
                        hintStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: _isLoadingLocation ? Colors.grey : const Color(0xFF2A5C99),
                    ),
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  ),
                ],
              ),
              if (_locationText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Coordonnées: $_locationText',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Description
              _buildSectionTitle('Description détaillée'),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Décrivez le problème en détail...',
                  hintStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  if (value.length < 20) {
                    return 'Veuillez fournir plus de détails';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildAudioRecordingSection(),
              const SizedBox(height: 20),
              // Niveau d'urgence
              _buildSectionTitle('Niveau d\'urgence'),
              _buildDropdown(
                value: _urgencyLevel,
                items: _urgencyLevels,
                onChanged: (value) => setState(() => _urgencyLevel = value!),
              ),
              const SizedBox(height: 20),

              // Signalement anonyme
              Row(
                children: [
                  Checkbox(
                    value: _anonymousReport,
                    onChanged: (value) => setState(() => _anonymousReport = value!),
                    activeColor: const Color(0xFF2A5C99),
                  ),
                  Text(
                    'Signalement anonyme',
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A5C99),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Envoyer le signalement',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: GoogleFonts.poppins()),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Column(
      children: [
        InkWell(
          onTap: _getImage,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            child: _selectedImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _selectedImage!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajouter une photo',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_selectedImage != null)
          TextButton(
            onPressed: () => setState(() => _selectedImage = null),
            child: Text(
              'Supprimer la photo',
              style: GoogleFonts.poppins(
                color: const Color(0xFFD93E30),
              ),
            ),
          ),
      ],
    );
  }
}