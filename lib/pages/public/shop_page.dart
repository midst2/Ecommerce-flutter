import 'package:ecommerce/components/shoe_listview.dart';
import 'package:ecommerce/utils/shoedata.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(hintText: "Search"),
                  ),
                ),
                const Icon(Icons.search),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text("The best shoe company on the planet!"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Hot Picks",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemCount: shoeData.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ShoeListview(
                name: shoeData[index]["name"],
                price: shoeData[index]["price"],
                description: shoeData[index]["description"],
                imagePath: shoeData[index]["imagePath"],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(border: Border.all(width: 0.1)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "For Kids",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent:
                    250, // try 250-280 to fit image + text + button
              ),
              itemCount: shoeData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ShoeListview(
                name: shoeData[shoeData.length - index - 1]["name"],
                price: shoeData[shoeData.length - index - 1]["price"],
                description:
                    shoeData[shoeData.length - index - 1]["description"],
                imagePath: shoeData[shoeData.length - index - 1]["imagePath"],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
