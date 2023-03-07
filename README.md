# Tá Chegandp

Aplicativo em Flutter para rastreio de encomenda.

## Lançar APK de nova versão

1. Colar o arquivo `key.jks` dentro do diretório `android/app/`.

2. Colar o arquivo `key.properties` dentro do diretório `android/`.

3. Para gerar o bundle de produção, utilizar o comando:

```shell
flutter build appbundle
```

6. Após finalizar a execução, o bundle estará em `build/app/outputs/bundle/release/app-release.aab`.
