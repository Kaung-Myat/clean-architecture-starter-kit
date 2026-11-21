import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/localization/generated/translations.g.dart';
import '../../../../core/network/exceptions/api_exception.dart';
import '../../../../core/utils/form_field_errors.dart';
import '../../../../core/utils/validators/validators.dart';
import '../../../../shared/widgets/app_elevated_button.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/create_post_controller.dart';
import '../providers/posts_list_controller.dart';

/// Form convention sample: local [Validators] + server [FormFieldErrors].
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  FormFieldErrors _fieldErrors = const FormFieldErrors();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _fieldErrors = const FormFieldErrors());
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final created = await ref.read(createPostControllerProvider.notifier).submit(
          title: _titleController.text,
          body: _bodyController.text,
        );
    if (!mounted) return;

    if (created != null) {
      AppToast.success(context, context.t.posts.created);
      ref.invalidate(postsListControllerProvider);
      context.pop();
      return;
    }

    final error = ref.read(createPostControllerProvider).error;
    if (error is ApiException && error.errors.isNotEmpty) {
      setState(() => _fieldErrors = FormFieldErrors.fromApi(error));
      _formKey.currentState?.validate();
    } else if (error is ApiException) {
      AppToast.error(context, error.message);
    } else if (error != null) {
      AppToast.error(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final createState = ref.watch(createPostControllerProvider);
    final isLoading = createState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(t.posts.createTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                label: t.posts.titleField,
                hint: t.posts.titleHint,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_fieldErrors['title'] != null) {
                    setState(() => _fieldErrors = _fieldErrors.without('title'));
                  }
                },
                validator: (value) {
                  return _fieldErrors['title'] ??
                      Validators.required(value, field: t.posts.titleField);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _bodyController,
                label: t.posts.bodyField,
                hint: t.posts.bodyHint,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: (_) {
                  if (_fieldErrors['body'] != null) {
                    setState(() => _fieldErrors = _fieldErrors.without('body'));
                  }
                },
                validator: (value) {
                  return _fieldErrors['body'] ??
                      Validators.required(value, field: t.posts.bodyField);
                },
              ),
              const SizedBox(height: 12),
              Text(
                t.posts.validationHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton(
                  label: t.posts.submit,
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
