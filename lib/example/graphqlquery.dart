import 'package:graphql_flutter/graphql_flutter.dart';

final getUserQuery = gql(r'''
query {
  countries {
    code
    name
    emoji
  }
}
''');
