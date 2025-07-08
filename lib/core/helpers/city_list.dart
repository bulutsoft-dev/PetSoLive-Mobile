class CityList {
  static const List<String> cities = [
    "Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin", "Aydın", "Balıkesir", "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli", "Diyarbakır", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin", "İstanbul", "İzmir", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa", "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"
  ];

  static List<String> getDistrictsByCity(String city) {
    switch (city) {
      case "Adana": return ["Seyhan", "Yüreğir", "Çukurova", "Ceyhan"];
      case "Adıyaman": return ["Merkez", "Besni", "Kahta", "Gölbaşı"];
      case "Afyonkarahisar": return ["Merkez", "Sandıklı", "Emirdağ", "Dinar"];
      case "Ağrı": return ["Merkez", "Patnos", "Doğubayazıt", "Eleşkirt"];
      case "Amasya": return ["Merkez", "Suluova", "Merzifon", "Taşova"];
      case "Ankara": return ["Çankaya", "Keçiören", "Mamak", "Etimesgut"];
      case "Antalya": return ["Muratpaşa", "Kepez", "Konyaaltı", "Alanya"];
      case "Artvin": return ["Merkez", "Hopa", "Arhavi", "Yusufeli"];
      case "Aydın": return ["Efeler", "Nazilli", "Söke", "Kuşadası"];
      case "Balıkesir": return ["Altıeylül", "Karesi", "Edremit", "Bandırma"];
      case "Bilecik": return ["Merkez", "Bozüyük", "Söğüt", "Pazaryeri"];
      case "Bingöl": return ["Merkez", "Genç", "Solhan", "Karlıova"];
      case "Bitlis": return ["Merkez", "Tatvan", "Ahlat", "Adilcevaz"];
      case "Bolu": return ["Merkez", "Gerede", "Mengen", "Mudurnu"];
      case "Burdur": return ["Merkez", "Bucak", "Yeşilova", "Gölhisar"];
      case "Bursa": return ["Osmangazi", "Yıldırım", "Nilüfer", "İnegöl"];
      case "Çanakkale": return ["Merkez", "Biga", "Çan", "Gelibolu"];
      case "Çankırı": return ["Merkez", "Çerkeş", "Ilgaz", "Kurşunlu"];
      case "Çorum": return ["Merkez", "Sungurlu", "Alaca", "Osmancık"];
      case "Denizli": return ["Pamukkale", "Merkezefendi", "Çivril", "Tavas"];
      case "Diyarbakır": return ["Bağlar", "Kayapınar", "Yenişehir", "Ergani"];
      case "Edirne": return ["Merkez", "Keşan", "Uzunköprü", "Havsa"];
      case "Elazığ": return ["Merkez", "Kovancılar", "Karakoçan", "Maden"];
      case "Erzincan": return ["Merkez", "Tercan", "Üzümlü", "Çayırlı"];
      case "Erzurum": return ["Yakutiye", "Palandöken", "Aziziye", "Horasan"];
      case "Eskişehir": return ["Tepebaşı", "Odunpazarı", "Sivrihisar", "Çifteler"];
      case "Gaziantep": return ["Şahinbey", "Şehitkamil", "Nizip", "İslahiye"];
      case "Giresun": return ["Merkez", "Bulancak", "Görele", "Espiye"];
      case "Gümüşhane": return ["Merkez", "Kelkit", "Şiran", "Köse"];
      case "Hakkari": return ["Merkez", "Yüksekova", "Çukurca", "Şemdinli"];
      case "Hatay": return ["Antakya", "İskenderun", "Dörtyol", "Samandağ"];
      case "Isparta": return ["Merkez", "Yalvaç", "Eğirdir", "Şarkikaraağaç"];
      case "Mersin": return ["Yenişehir", "Toroslar", "Akdeniz", "Tarsus"];
      case "İstanbul": return ["Kadıköy", "Beşiktaş", "Üsküdar", "Fatih"];
      case "İzmir": return ["Karşıyaka", "Konak", "Bornova", "Buca"];
      case "Kars": return ["Merkez", "Sarıkamış", "Kağızman", "Akyaka"];
      case "Kastamonu": return ["Merkez", "Tosya", "Taşköprü", "İnebolu"];
      case "Kayseri": return ["Melikgazi", "Kocasinan", "Talas", "Develi"];
      case "Kırklareli": return ["Merkez", "Lüleburgaz", "Babaeski", "Vize"];
      case "Kırşehir": return ["Merkez", "Kaman", "Mucur", "Çiçekdağı"];
      case "Kocaeli": return ["İzmit", "Gebze", "Darıca", "Körfez"];
      case "Konya": return ["Selçuklu", "Karatay", "Meram", "Ereğli"];
      case "Kütahya": return ["Merkez", "Tavşanlı", "Simav", "Emet"];
      case "Malatya": return ["Yeşilyurt", "Battalgazi", "Doğanşehir", "Akçadağ"];
      case "Manisa": return ["Akhisar", "Turgutlu", "Salihli", "Alaşehir"];
      case "Kahramanmaraş": return ["Dulkadiroğlu", "Onikişubat", "Elbistan", "Afşin"];
      case "Mardin": return ["Artuklu", "Midye", "Nusaybin", "Kızıltepe"];
      case "Muğla": return ["Menteşe", "Bodrum", "Fethiye", "Marmaris"];
      case "Muş": return ["Merkez", "Bulanık", "Malazgirt", "Varto"];
      case "Nevşehir": return ["Merkez", "Ürgüp", "Avanos", "Gülşehir"];
      case "Niğde": return ["Merkez", "Bor", "Ulukışla", "Çamardı"];
      case "Ordu": return ["Altınordu", "Ünye", "Fatsa", "Perşembe"];
      case "Rize": return ["Merkez", "Çayeli", "Pazar", "Ardeşen"];
      case "Sakarya": return ["Adapazarı", "Serdivan", "Akyazı", "Hendek"];
      case "Samsun": return ["İlkadım", "Atakum", "Canik", "Bafra"];
      case "Siirt": return ["Merkez", "Kurtalan", "Pervari", "Baykan"];
      case "Sinop": return ["Merkez", "Boyabat", "Ayancık", "Durağan"];
      case "Sivas": return ["Merkez", "Şarkışla", "Suşehri", "Zara"];
      case "Tekirdağ": return ["Çorlu", "Süleymanpaşa", "Malkara", "Çerkezköy"];
      case "Tokat": return ["Merkez", "Turhal", "Zile", "Erbaa"];
      case "Trabzon": return ["Ortahisar", "Akçaabat", "Araklı", "Vakfıkebir"];
      case "Tunceli": return ["Merkez", "Pertek", "Çemişgezek", "Hozat"];
      case "Şanlıurfa": return ["Haliliye", "Eyyübiye", "Karaköprü", "Siverek"];
      case "Uşak": return ["Merkez", "Banaz", "Sivaslı", "Eşme"];
      case "Van": return ["İpekyolu", "Edremit", "Tuşba", "Erciş"];
      case "Yozgat": return ["Merkez", "Sorgun", "Akdağmadeni", "Boğazlıyan"];
      case "Zonguldak": return ["Merkez", "Ereğli", "Devrek", "Çaycuma"];
      case "Aksaray": return ["Merkez", "Sultanhanı", "Eskil", "Ortaköy"];
      case "Bayburt": return ["Merkez", "Aydıntepe", "Demirözü", "Diğer"];
      case "Karaman": return ["Merkez", "Ermenek", "Ayrancı", "Sarıveliler"];
      case "Kırıkkale": return ["Merkez", "Keskin", "Delice", "Sulakyurt"];
      case "Batman": return ["Merkez", "Kozluk", "Sason", "Hasankeyf"];
      case "Şırnak": return ["Merkez", "Cizre", "Silopi", "İdil"];
      case "Bartın": return ["Merkez", "Amasra", "Ulus", "Kurucaşile"];
      case "Ardahan": return ["Merkez", "Göle", "Hanak", "Posof"];
      case "Iğdır": return ["Merkez", "Tuzluca", "Aralık", "Karakoyunlu"];
      case "Yalova": return ["Merkez", "Çınarcık", "Termal", "Altınova"];
      case "Karabük": return ["Merkez", "Safranbolu", "Yenice", "Eflani"];
      case "Kilis": return ["Merkez", "Musabeyli", "Polateli", "Diğer"];
      case "Osmaniye": return ["Merkez", "Kadirli", "Düziçi", "Bahçe"];
      case "Düzce": return ["Merkez", "Akçakoca", "Yığılca", "Gölyaka"];
      default: return ["Diğer"];
    }
  }
} 