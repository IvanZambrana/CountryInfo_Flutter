//login exceptions
class UserNotFoundAuthException implements Exception {}
class WrongPasswordAuthException implements Exception {}

//Register exceptions
class WeakPasswordAuthException implements Exception {}
class EmailArleadyInUseAuthException implements Exception {}
class InvalidEmailAuthException implements Exception {}

//Generic exceptions
class GenericAuthException implements Exception {}
class UserNotLoggedInAuthException implements Exception {}
