import 'package:ddd_practice_flutter/application/notes/note_form/bloc/note_form_bloc.dart';
import 'package:ddd_practice_flutter/domain/notes/value_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorField extends StatelessWidget {
  const ColorField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (previous, current) =>
          previous.note.color != current.note.color,
      builder: (context, state) {
        return Container(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: ((context, index) {
              final itemColor = NoteColor.predefinedColors[index];
              return GestureDetector(
                onTap: () {
                  context.read<NoteFormBloc>().add(
                        NoteFormEvent.colorChanged(itemColor),
                      );
                },
                child: Material(
                  color: itemColor,
                  elevation: 4,
                  shape: CircleBorder(
                    side: state.note.color.value.fold(
                      (l) => BorderSide.none,
                      ((color) => color == itemColor
                          ? BorderSide(width: 1.5)
                          : BorderSide.none),
                    ),
                  ),
                  child: Container(
                    height: 50,
                    width: 50,
                  ),
                ),
              );
            }),
            separatorBuilder: (context, index) => const SizedBox(
              width: 12,
            ),
            itemCount: NoteColor.predefinedColors.length,
          ),
        );
      },
    );
  }
}
