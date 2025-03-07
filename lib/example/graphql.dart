import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink _httpLink = HttpLink("https://countries.trevorblades.com");

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(link: _httpLink, cache: GraphQLCache()),
);
