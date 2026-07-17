import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:xuan_common_ui/xuan_common_ui.dart';
import 'package:daliuren/presentation/viewmodels/da_liu_ren_viewmodel.dart';
import 'package:daliuren/presentation/views/widgets/datetime_selector_widget.dart';
import 'package:daliuren/presentation/views/widgets/divination_display_widget.dart';
import 'package:daliuren/presentation/views/widgets/loading_widget.dart';
import 'package:daliuren/presentation/views/widgets/error_widget.dart';

class DaLiuRenView extends StatefulWidget {
  const DaLiuRenView({super.key});

  @override
  State<DaLiuRenView> createState() => _DaLiuRenViewState();
}

class _DaLiuRenViewState extends State<DaLiuRenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DaLiuRenViewModel>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: XuanAppBar(
        title: Consumer<DaLiuRenViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.currentDivination != null &&
                viewModel.juNumber != null) {
              final divination = viewModel.currentDivination!;
              return Text(
                l10n.divinationTime(
                  divination.dayJiaZi.name,
                  divination.timeJiaZi.diZhi.name,
                  divination.isDayGuiRen ? l10n.yang : l10n.yin,
                  '${viewModel.juNumber}',
                ),
              );
            }
            return Text(l10n.appTitle);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DaLiuRenViewModel>().recalculate();
            },
          ),
        ],
      ),
      body: Consumer<DaLiuRenViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const LoadingWidget();
          }

          if (viewModel.isError) {
            return CustomErrorWidget(
              message: viewModel.message,
              onRetry: () => viewModel.initializeData(),
            );
          }

          return const Column(
            children: [
              DateTimeSelectorWidget(),
              Expanded(
                child: DivinationDisplayWidget(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DaLiuRenViewModel>().resetToNow();
        },
        child: const Icon(Icons.access_time),
      ),
    );
  }
}
