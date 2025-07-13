# API Key Kurulumu

## Sorun
PetSoLive uygulamasında API key eksik veya geçersiz olduğu için API çağrıları başarısız oluyor.

## Çözüm

### 1. API Key'i Güncelleyin
`lib/core/constants/api_constants.dart` dosyasındaki API key'i güncelleyin:

```dart
static const String apiKey = 'GERÇEK_API_KEY_BURAYA';
```

### 2. Backend Ekibiyle İletişime Geçin
Eğer gerçek API key'e sahip değilseniz, backend ekibiyle iletişime geçerek:
- PetSoLive API key'ini alın
- API endpoint'lerinin doğru çalıştığını kontrol edin

### 3. Test Edin
API key'i güncelledikten sonra:
1. Uygulamayı yeniden başlatın
2. Kayıt ve giriş işlemlerini test edin
3. Console'da hata mesajlarını kontrol edin

### 4. Geçici Çözüm
Eğer API key henüz mevcut değilse, aşağıdaki değeri kullanabilirsiniz:
```dart
static const String apiKey = 'petsolive-api-key-2024';
```

## Hata Mesajları
- "API Key eksik veya geçersiz" → API key'i güncelleyin
- "401 Unauthorized" → API key yanlış veya eksik
- "API Key geçersiz veya eksik" → Backend ekibiyle iletişime geçin

## Not
Bu dosya sadece geliştirme amaçlıdır ve production'da kullanılmamalıdır. 