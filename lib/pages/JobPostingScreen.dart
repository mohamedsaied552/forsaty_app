import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forsaty/logic/post/post_bloc.dart';
import 'package:forsaty/logic/post/post_event.dart';
import 'package:forsaty/logic/post/post_state.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(),
      child: const _CreatePostView(),
    );
  }
}

class _CreatePostView extends StatefulWidget {
  const _CreatePostView();

  @override
  State<_CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<_CreatePostView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _extraTitleController = TextEditingController();
  final _extraDescController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _extraTitleController.dispose();
    _extraDescController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia(BuildContext context) async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;

    final files = picked.map((x) => File(x.path)).toList();
    context.read<PostBloc>().add(PostMediaAdded(files));
  }

  void _submit(BuildContext context, PostState state) {
    // Replace later with FirebaseAuth user values
    const userId = 'demo_user_id';
    const name = 'Demo User';

    context.read<PostBloc>().add(
      const PostSubmitted(userId: userId, name: name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state.status == PostStatus.success) Navigator.pop(context);

        if (state.status == PostStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      title: 'Create New Post',
                      onClose: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F8FB),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _LabeledTextField(
                            label: 'Title',
                            hint: 'Enter title',
                            controller: _titleController,
                            onChanged: (v) => context.read<PostBloc>().add(
                              PostTitleChanged(v),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _LabeledTextArea(
                            label: 'Description',
                            hint: 'Write something...',
                            controller: _descController,
                            onChanged: (v) => context.read<PostBloc>().add(
                              PostDescriptionChanged(v),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _LabeledTextField(
                            label: 'Subtitle (Optional)',
                            hint: 'Enter subtitle',
                            controller: _extraTitleController,
                            onChanged: (v) => context.read<PostBloc>().add(
                              PostExtraTitleChanged(v),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _LabeledTextArea(
                            label: 'Details (Optional)',
                            hint: 'Add more details...',
                            controller: _extraDescController,
                            onChanged: (v) => context.read<PostBloc>().add(
                              PostExtraDescriptionChanged(v),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add Media ( Optional )',
                              style: _textStyle(
                                20,
                                FontWeight.w600,
                                const Color(0xFF4C5560),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _pickMedia(context),
                            child: Container(
                              height: 142,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.upload_file,
                                      size: 32,
                                      color: Color(0xFF1B384A),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Upload Files',
                                      style: _textStyle(
                                        18,
                                        FontWeight.w400,
                                        const Color(0xFF1B384A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<PostBloc, PostState>(
                            builder: (context, state) {
                              if (state.mediaFiles.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                  state.mediaFiles.length,
                                  (i) {
                                    final file = state.mediaFiles[i];
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            file,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: InkWell(
                                            onTap: () => context
                                                .read<PostBloc>()
                                                .add(PostMediaRemoved(i)),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          BlocBuilder<PostBloc, PostState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  _ToggleRow(
                                    label: 'Allow your connection to Repost',
                                    value: state.allowRepost,
                                    onChanged: (v) => context
                                        .read<PostBloc>()
                                        .add(PostAllowRepostToggled(v)),
                                  ),
                                  const SizedBox(height: 12),
                                  _ToggleRow(
                                    label: 'Visible to all',
                                    value: state.visibleToAll,
                                    onChanged: (v) => context
                                        .read<PostBloc>()
                                        .add(PostVisibleToAllToggled(v)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  color: Colors.white,
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      final isLoading = state.status == PostStatus.loading;
                      return Row(
                        children: [
                          Expanded(
                            child: _SecondaryButton(
                              text: 'Cancel',
                              onTap: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PrimaryButton(
                              text: isLoading ? 'Posting...' : 'Post',
                              onTap: (!state.canSubmit || isLoading)
                                  ? null
                                  : () => _submit(context, state),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* UI */

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const _Header({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: _textStyle(26, FontWeight.w700, Colors.black),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Color(0xFF9A9A9A)),
          ),
        ],
      ),
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _LabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _textStyle(20, FontWeight.w600, const Color(0xFF596574)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _textStyle(18, FontWeight.w400, const Color(0xFF858C95)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E5E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFB2D5FF)),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledTextArea extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _LabeledTextArea({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _textStyle(20, FontWeight.w600, const Color(0xFF4C5560)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          onChanged: onChanged,
          minLines: 4,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _textStyle(18, FontWeight.w400, const Color(0xFF979AA0)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E5E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFB2D5FF)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: _textStyle(20, FontWeight.w600, const Color(0xFF4C5560)),
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _SecondaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(color: Color(0xFFB2D5FF)),
          backgroundColor: const Color(0xFFECF4FC),
        ),
        child: Text(
          text,
          style: _textStyle(16, FontWeight.w600, const Color(0xFF1B384A)),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: const Color(0xFF1B384A),
        ),
        child: Text(text, style: _textStyle(18, FontWeight.w600, Colors.white)),
      ),
    );
  }
}

TextStyle _textStyle(double size, FontWeight weight, Color color) {
  return TextStyle(
    fontFamily: 'Josefin Sans',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.2,
  );
}
