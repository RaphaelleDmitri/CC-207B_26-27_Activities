# Unit 6 Assignment – CICT Org Fair 2

## E1. Lifting State Up

**Location:** `lib/screens/home_shell.dart` — `_memberships` map (line number: 26).

The `HomeShell` owns the memberships because both the My Orgs screen and the Schedule screen need to know which organizations the student joined. Keeping the data in one shared place makes sure both screens display consistent information when a membership changes.

## E2. IndexedStack and Preserving State

**Location:** `lib/screens/home_shell.dart` — `IndexedStack` in `build()` (line number: 58).

The `IndexedStack` keeps the tab pages alive even when they are not currently visible. This allows the Orgs screen to retain its search text when I switch to another tab and return instead of rebuilding the page from scratch.

## E3. Closing the Drawer Before Opening About

**Location:** `lib/screens/org_list_screen.dart` — `_buildDrawer()` (line number: 118).

The drawer is closed using `Navigator.pop(context)` before opening the About screen with `Navigator.pushNamed()`. This removes the drawer from the screen first and makes the navigation transition behave properly.

## E4. Wrap vs. Row

**Location:** `lib/screens/org_list_screen.dart` — category `Wrap` (line number: 264).

A `Wrap` allows the filter chips to move onto another line when there is not enough horizontal space. A `Row` tries to keep all its children on one line, which can cause a horizontal overflow when the chips do not fit.

## E5. SliverGridDelegateWithMaxCrossAxisExtent

**Location:** `lib/screens/org_list_screen.dart` — `_buildGrid()` (line number: 293).

`SliverGridDelegateWithMaxCrossAxisExtent` limits the maximum width of each grid item instead of forcing a fixed number of columns. Flutter calculates how many columns can fit based on the available width, so the grid can adjust to different screen sizes.

## E6. Matching Tab Counts

**Location:** `lib/screens/org_detail_screen.dart` — `DefaultTabController`, `TabBar`, and `TabBarView` (line number: 37).

The controller length, the number of tabs in the `TabBar`, and the number of children in the `TabBarView` must all match. If the counts do not match, Flutter can throw an error because the controller and the displayed tab pages are inconsistent.

## E7. Nullable Dialog Results

**Location:** `lib/screens/my_orgs_screen.dart` — `_confirmLeave()` (line number: 28).

The result of `showDialog<bool>` is a nullable Boolean because the dialog can be dismissed without the user choosing either button. Checking `confirmed == true` ensures that the organization is removed only when the user explicitly presses Leave, not when they cancel or dismiss the dialog.

## E8. Table vs. Column of Rows

**Location:** `lib/screens/schedule_screen.dart` — `Table` widget (line number: 55).

A `Table` aligns cells into shared columns, making the schedule easier to read. If I used a `Column` containing separate `Row` widgets, each row could size its children independently, causing the time, booth, and organization columns to become misaligned.