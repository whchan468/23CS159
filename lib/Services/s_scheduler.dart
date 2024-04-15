class SScheduler {
  static List<DateTime> scheduleTask(
    int freq,
    int times,
    DateTime sdate,
    DateTime edate,
    DateTime wtime,
    DateTime btime,
    List<DateTime> mealTime,
    List<String>? remarks,
  ) {
    if (remarks == null || remarks.isEmpty) {
      //    add first schedule
      List<DateTime> schedule = [];
      DateTime date = sdate;
      schedule.add(date);

      //    schedule remaining time of the day
      int remainingTimes = getRemainingTimes(freq, times, sdate, btime);
      for (int i = 0; i < remainingTimes - 1; i++) {
        date = scheduleNextEvent(freq, date);
        schedule.add(date);
      }
      date = nextDay(date, wtime);
      schedule.add(date);
      //    schedule full days
      num adjustedFreq = getPossibleFreq(freq, times, wtime, btime);
      var duration = Duration(
          hours: adjustedFreq.toInt(),
          minutes: ((adjustedFreq - adjustedFreq.toInt()) * 60).round());
      int dosageCount = 1;
      while (date.add(duration).isBefore(edate)) {
        //    new day if time is after btime

        if (dosageCount < times) {
          dosageCount++;
          date = scheduleNextEvent(adjustedFreq, date);
          schedule.add(date);
        } else {
          date = nextDay(date, wtime);
          schedule.add(date);
          dosageCount = 1;
        }
      }
      return schedule;
    } else if (remarks.contains("when needed")) {
      return [];
    } else if (remarks.contains('before meals')) {
      //    add first schedule
      List<DateTime> schedule = [];
      DateTime date = sdate;
      var threshold = 2;
      var tmp = checkRescheduling(
          date, threshold, beforeMeals, mealTime, sdate, edate);
      if (tmp != null) {
        schedule.add(tmp);
      }

      //    schedule remaining time of the day
      int remainingTimes = getRemainingTimes(freq, times, sdate, btime);
      for (int i = 0; i < remainingTimes - 1; i++) {
        var tempDate = scheduleNextEvent(freq, date);
        var newdate = checkRescheduling(
            tempDate, threshold, beforeMeals, mealTime, sdate, edate);
        if (newdate != null) {
          date = newdate;
          schedule.add(date);
        }
      }
      date = nextDay(date, wtime);
      schedule.add(date);
      //    schedule full days
      num adjustedFreq = getPossibleFreq(freq, times, wtime, btime);
      var duration = Duration(
          hours: adjustedFreq.toInt(),
          minutes: ((adjustedFreq - adjustedFreq.toInt()) * 60).round());
      int dosageCount = 1;
      while (date.add(duration).isBefore(edate)) {
        if (dosageCount < times) {
          var tempDate = scheduleNextEvent(adjustedFreq, date);
          var newdate = checkRescheduling(
              tempDate, threshold, beforeMeals, mealTime, sdate, edate);
          if (newdate != null) {
            dosageCount++;
            date = newdate;
            schedule.add(date);
          }
        } else {
          date = nextDay(date, wtime);
          schedule.add(date);
          dosageCount = 1;
        }
      }
      return schedule;
    } else if (remarks.contains('after meals')) {
      //    add first schedule
      List<DateTime> schedule = [];
      DateTime date = sdate;
      //    define threshold as 2
      int amThreshold = 2;

      //    schedule first time
      if (afterMeals(mealTime,
          mealTime.first.copyWith(hour: date.hour, minute: date.minute))) {
        schedule.add(date);
      } else {
        date = findNextMeal(date, mealTime);
        if (date.isBefore(sdate)) {
          date = sdate;
        } else {
          schedule.add(date);
        }
      }

      //    get remaining times of first day
      int remainingTimes = getRemainingTimes(freq, times, sdate, btime);
      for (int i = 0; i < remainingTimes - 1; i++) {
        var tempDate = scheduleNextEvent(freq, date);
        var newdate = checkRescheduling(
            tempDate, amThreshold, afterMeals, mealTime, sdate, edate);
        if (newdate != null) {
          date = newdate;
          schedule.add(date);
        }
        //    scheduled time too far from meal time, following scheduled time and noted with remarks

        else {
          date = tempDate;
          schedule.add(date);
        }
      }
      date = nextDay(date, wtime);
      if (afterMeals(mealTime,
          mealTime.first.copyWith(hour: date.hour, minute: date.minute))) {
        schedule.add(date);
      } else {
        date = findNextMeal(date, mealTime);
        schedule.add(date);
      }
      //    schedule full days
      num adjustedFreq = getPossibleFreq(freq, times, wtime, btime);
      var duration = Duration(
          hours: adjustedFreq.toInt(),
          minutes: ((adjustedFreq - adjustedFreq.toInt()) * 60).round());
      int dosageCount = 1;
      DateTime today = DateTime(date.year, date.month, date.day);
      while (date.add(duration).isBefore(edate)) {
        if (dosageCount < times) {
          var tempDate = scheduleNextEvent(adjustedFreq, date);
          var newdate = checkRescheduling(
              tempDate, amThreshold, afterMeals, mealTime, sdate, edate);
          if (newdate != null) {
            dosageCount++;
            date = newdate;
            schedule.add(date);
          }
          //    scheduled time too far from meal time, following scheduled time and noted with remarks
          else {
            date = tempDate;
            //    check if date is out of btime
            if (!date.isAfter(
                today.copyWith(hour: btime.hour, minute: btime.minute))) {
              dosageCount++;
              schedule.add(date);
            } else {
              //    decide if dose time is reasonable (0.75 freq)
              dosageCount++;
              if (freq - getTimeRange(btime, date) > 0.75 * freq) {
                schedule
                    .add(date.copyWith(hour: btime.hour, minute: btime.minute));
              }
            }
          }
        } else {
          date = nextDay(date, wtime);
          today = DateTime(date.year, date.month, date.day);
          dosageCount = 1;
          if (afterMeals(mealTime,
              mealTime.first.copyWith(hour: date.hour, minute: date.minute))) {
            schedule.add(date);
          } else {
            date = findNextMeal(date, mealTime);
            schedule.add(date);
          }
        }
      }
      return schedule;
    }
    return [];
  }

  static DateTime scheduleNextEvent(num freq, DateTime date) {
    DateTime nextEvent;
    nextEvent = date.add(Duration(
        hours: freq.toInt(), minutes: ((freq - freq.toInt()) * 60).round()));
    return nextEvent;
  }

  static DateTime? rescheduleEvent(
      DateTime date,
      int thresholdHours,
      Function function,
      List<DateTime> mealTime,
      DateTime sdate,
      DateTime edate) {
    int period = 15;
    DateTime newDate;
    //    postpone / advance 0.25 hours off and check if its suits the rule
    for (int i = 1; i <= thresholdHours * 4; i++) {
      //postpone
      newDate = date.add(Duration(minutes: period * i));
      if (!newDate.isAfter(edate) &&
          function(
              mealTime,
              mealTime.first
                  .copyWith(hour: newDate.hour, minute: newDate.minute))) {
        return newDate;
      } else {
        newDate = date.subtract(Duration(minutes: period * i));
        if (!newDate.isBefore(sdate) &&
            function(
                mealTime,
                mealTime.first
                    .copyWith(hour: newDate.hour, minute: newDate.minute))) {
          return newDate;
        }
      }
    }
    return null;
  }

  static DateTime? checkRescheduling(DateTime date, int threshold,
      Function function, List<DateTime> mealTime, sdate, edate) {
    if (function(mealTime,
        mealTime.first.copyWith(hour: date.hour, minute: date.minute))) {
      return date;
    } else {
      // rescheduling
      // threshold: +- 2 hours
      var newDate =
          rescheduleEvent(date, threshold, function, mealTime, sdate, edate);
      if (newDate != null) {
        date = newDate;
        return date;
      }
    }
    return null;
  }

  static bool beforeMeals(List<DateTime> mealTime, DateTime time) {
    for (var meal in mealTime) {
      if (time.isBefore(meal.add(const Duration(hours: 2))) &&
          time.isAfter(meal.subtract(const Duration(hours: 1)))) {
        return false;
      }
    }
    return true;
  }

  static bool afterMeals(List<DateTime> mealTime, DateTime time) {
    for (var meal in mealTime) {
      if (time.isBefore(meal.add(const Duration(hours: 1))) &&
          !time.isBefore(meal)) {
        return true;
      }
    }
    return false;
  }

  //    adjust frequency hours if time range not able to take all doses
  static num getPossibleFreq(
      int freq, int times, DateTime wtime, DateTime btime) {
    int range = getTimeRange(wtime, btime);
    if (range > freq * (times - 1)) return freq;
    return range / (times - 1);
  }

  static int getRemainingTimes(
      int freq, int times, DateTime stime, DateTime btime) {
    int range = getTimeRange(stime, btime);
    if (range > freq * (times - 1)) return times;
    return (range / freq).toInt() + 1;
  }

  static int getTimeRange(DateTime startTime, DateTime endTime) {
    int range = DateTime(2000, 1, 1, endTime.hour, endTime.minute)
        .difference(DateTime(2000, 1, 1, startTime.hour, startTime.minute))
        .inHours;
    if (range < 0) range += 24;
    return range;
  }

  static DateTime nextDay(DateTime date, DateTime wtime) {
    if (compareTime(date, wtime) == -1) {
      return date.copyWith(hour: wtime.hour, minute: wtime.minute);
    } else {
      DateTime nextDay = date.add(const Duration(days: 1));
      return nextDay.copyWith(hour: wtime.hour, minute: wtime.minute);
    }
  }

  static int compareTime(DateTime time1, DateTime time2) {
    var stime1 = DateTime(2000, 1, 1, time1.hour, time1.minute);
    var stime2 = DateTime(2000, 1, 1, time2.hour, time2.minute);
    if (stime1 == stime2) return 0;
    if (stime1.isAfter(stime2))
      return 1;
    else
      return -1;
  }

  static DateTime findNextMeal(DateTime time, List<DateTime> mealTime) {
    for (var meal in mealTime) {
      if (compareTime(meal, time) >= 0) {
        return meal.copyWith(year: time.year, month: time.month, day: time.day);
      }
    }
    return mealTime[0]
        .copyWith(year: time.year, month: time.month, day: time.day);
  }
}
