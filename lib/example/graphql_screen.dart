import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_tasks_pro/example/graphqlquery.dart';

class GraphqlScreen extends StatelessWidget {
  const GraphqlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GraphQL Example")),
      body: Query(
        options: QueryOptions(document: getUserQuery),
        builder: (
          QueryResult result, {
          Future<QueryResult> Function(FetchMoreOptions)? fetchMore,
          Future<QueryResult?> Function()? refetch,
        }) {
          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception.toString()}"));
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List countries = result.data?["countries"];
          if (countries.isEmpty) {
            return const Center(child: Text("No Data Available"));
          }

          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                leading: Text(
                  country["emoji"],
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(country["name"]),
                subtitle: Text(country["code"]),
              );
            },
          );
        },
      ),
    );
  }
}
