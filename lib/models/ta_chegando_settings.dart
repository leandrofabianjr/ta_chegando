class TaChegandoSettings {
  String? token;

  TaChegandoSettings({
    this.token,
  });

  static TaChegandoSettings? fromJson(json) {
    if (json == null) return null;

    return TaChegandoSettings(
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
