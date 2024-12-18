import 'package:flutter/material.dart';

class QuestionNavigationPanel extends StatelessWidget {
  final int currentQuestionIndex;
  final List<String> questions; // List of question labels, e.g., "Q1", "Q2"
  final Function(int) onNavigateToQuestion;
  final VoidCallback onAddNewQuestion;

  const QuestionNavigationPanel({
    Key? key,
    required this.currentQuestionIndex,
    required this.questions,
    required this.onNavigateToQuestion,
    required this.onAddNewQuestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(questions.length, (index) {
                    return GestureDetector(
                      onTap: () => onNavigateToQuestion(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: index == currentQuestionIndex
                              ? Colors.blueAccent
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Text(
                          questions[index],
                          style: TextStyle(
                            color: index == currentQuestionIndex
                                ? Colors.white
                                : Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: onAddNewQuestion,
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
