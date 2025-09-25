import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/cart_model.dart';

class ShoeListview extends StatefulWidget {
  final String name;
  final int price;
  final String description;
  final String imagePath;
  const ShoeListview({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });

  @override
  State<ShoeListview> createState() => _ShoeListviewState();
}

class _ShoeListviewState extends State<ShoeListview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 200,
      margin: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${widget.price}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      final item = CartItem(
                        name: widget.name,
                        price: widget.price,
                        imagePath: widget.imagePath,
                      );
                      Provider.of<CartModel>(context, listen: false).addItem(item);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
