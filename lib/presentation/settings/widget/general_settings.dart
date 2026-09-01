import 'package:flutter/material.dart';

class GeneralSettings extends StatelessWidget {

  const GeneralSettings({ super.key });

   @override
   Widget build(BuildContext context) {
       return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
                'Geral',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0XFFA9A2B5),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0XFF110B1A),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    borderRadius:BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Como Jogar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0XFFF8F7FC),
                        ),
                      ),
                      Icon(Icons.link, color: Color(0XFFF8F7FC)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0XFF110B1A),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                      borderRadius:BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Perguntas frequentes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0XFFF8F7FC),
                        ),
                      ),
                      Icon(Icons.link, color: Color(0XFFF8F7FC)),
                    ],
                  ),
                ),
              ),
       ],);
  }
}