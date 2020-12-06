import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static final Link httpLink = HttpLink(
    uri: 'http://192.168.20.242:4000/graphql',
  );

  Link link;

  ValueNotifier<GraphQLClient> client() {
    return ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink,
      ),
    );
  }

  GraphQLClient clientToQuery({token}) {
    if (!(token == null)) {
      final AuthLink authLink = AuthLink(
        getToken: () => 'Bearer $token',
      );

      link = authLink.concat(httpLink);
    } else {
      link = httpLink;
    }
    return GraphQLClient(cache: InMemoryCache(), link: link);
  }
}
