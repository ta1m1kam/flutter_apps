import 'dart:async';
import 'dart:math' show Random;

class CalcBloc {
  final _startController = StreamController<void>();
  final _calcController = StreamController<int>();
  final _outputController = StreamController<String>();
  final _btnController = StreamController<bool>();

  // 入力用のsink Getter
  StreamSink<void> get start => _startController.sink;

  // 出力用のstream Getter
  Stream<String> get onAdd => _outputController.stream;
  Stream<bool> get onToggle => _btnController.stream;

  static const _repeat = 6;
  int _sum;
  Timer _timer;

  CalcBloc() {
    // スタートボタンが押されるのを待つ
    _startController.stream.listen((_) => _start());

    // 秒数が通知されるのを持つ
    _calcController.stream.listen((count) => _calc(count));

    // ボタンの表示を支持する
    _btnController.sink.add(true);
  }

  void _start() {
    _sum = 0;
    _outputController.sink.add('');
    _btnController.sink.add(false);

    // 1秒ごとに秒数を通知
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _calcController.sink.add(t.tick);
    });
  }

  void _calc(int count) {
    if (count < _repeat + 1) {
      final num = Random().nextInt(99) + 1;
      _outputController.sink.add('$num');
      _sum += num;
    } else {
      _timer.cancel();
      _outputController.sink.add('答えは$_sum');
      _btnController.sink.add(true);
    }
  }

  void dispose() {
    _startController.close();
    _calcController.close();
    _outputController.close();
    _btnController.close();
  }
}
