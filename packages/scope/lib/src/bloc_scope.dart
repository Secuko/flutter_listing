import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pure/pure.dart';

typedef ScopeData<D extends Object?> = D Function(
  BuildContext context, {
  bool listen,
});

typedef NullaryScopeMethod = void Function(BuildContext context);

typedef UnaryScopeMethod<A extends Object?> = void Function(
  BuildContext context,
  A argument,
);

@immutable
class BlocScope<E extends Object?, S extends Object?, B extends Bloc<E, S>> {
  @literal
  const BlocScope({
    bool listenByDefault = false,
  }) : _listenByDefault = listenByDefault;

  final bool _listenByDefault;

  S _state(B bloc) => bloc.state;

  B bloc(BuildContext context) => context.read<B>();

  ScopeData<D> data<D extends Object?>(
    D Function(BuildContext context, S state) data,
  ) =>
      // ignore: avoid_types_on_closure_parameters
      (context, {bool? listen}) => (listen ?? _listenByDefault)
          ? context.select<B, D>(data.curry(context).dot(_state))
          : data(context, bloc(context).state);

  ScopeData<D> select<D extends Object?>(D Function(S state) selector) =>
      data(selector.constant.uncurry);

  NullaryScopeMethod nullary(
    E? Function(BuildContext context) createEvent,
  ) =>
      (context) => bloc(context).add.nullable(
            createEvent(context),
          );

  UnaryScopeMethod<A> unary<A extends Object?>(
    E? Function(BuildContext context, A argument) createEvent,
  ) =>
      // ignore: avoid_types_on_closure_parameters
      (context, A argument) => bloc(context).add.nullable(
            createEvent(context, argument),
          );
}
