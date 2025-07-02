import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/adoption_bloc.dart';
import '../blocs/lost_pet_ad_bloc.dart';
import '../../data/repositories/adoption_repository_impl.dart';
import '../../data/repositories/lost_pet_ad_repository_impl.dart';
import '../../data/providers/adoption_api_service.dart';
import '../../data/providers/lost_pet_ad_api_service.dart';
import '../widgets/adoption_card.dart';
import '../widgets/lost_pet_ad_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/logo.png', height: 32),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Evlat Edinme'),
              Tab(text: 'Kayıp Hayvanlar'),
              Tab(text: 'Yardım Talepleri'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => AdoptionBloc(
                AdoptionRepositoryImpl(apiService: AdoptionApiService()),
              )..add(LoadAdoptions()),
              child: const AdoptionListView(),
            ),
            BlocProvider(
              create: (context) => LostPetAdBloc(
                LostPetAdRepositoryImpl(apiService: LostPetAdApiService()),
              )..add(LoadLostPetAds()),
              child: const LostPetAdListView(),
            ),
            const Center(child: Text('Yardım Talepleri')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Daha Fazla'),
          ],
          currentIndex: 0,
          onTap: (index) {
            // TODO: Navigation işlemleri eklenecek
          },
        ),
      ),
    );
  }
}

class AdoptionListView extends StatelessWidget {
  const AdoptionListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        if (state is AdoptionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdoptionLoaded) {
          if (state.adoptions.isEmpty) {
            return const Center(child: Text('Henüz evlat edinme ilanı yok.'));
          }
          return ListView.builder(
            itemCount: state.adoptions.length,
            itemBuilder: (context, index) {
              return AdoptionCard(adoption: state.adoptions[index]);
            },
          );
        } else if (state is AdoptionError) {
          return Center(child: Text('Hata: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class LostPetAdListView extends StatelessWidget {
  const LostPetAdListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LostPetAdBloc, LostPetAdState>(
      builder: (context, state) {
        if (state is LostPetAdLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LostPetAdLoaded) {
          if (state.ads.isEmpty) {
            return const Center(child: Text('Henüz kayıp hayvan ilanı yok.'));
          }
          return ListView.builder(
            itemCount: state.ads.length,
            itemBuilder: (context, index) {
              return LostPetAdCard(ad: state.ads[index]);
            },
          );
        } else if (state is LostPetAdError) {
          return Center(child: Text('Hata: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
} 