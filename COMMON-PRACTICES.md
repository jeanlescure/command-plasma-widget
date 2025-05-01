# Implementing Click-to-Show Popup Functionality in KDE Plasma Widgets

## Core Architecture

The Digital Clock widget uses a pattern common to KDE Plasma widgets with these key components:

1. **Main Component** (`main.qml`): Defines the overall widget structure and manages data connections
2. **Compact Representation** (`DigitalClock.qml`): Appears on the panel itself
3. **Full Representation** (`CalendarView.qml`): Appears when the widget is clicked

## Key Implementation Elements

### 1. PlasmoidItem Structure

In `main.qml`, the widget is implemented as a `PlasmoidItem` with these crucial properties:

```qml
PlasmoidItem {
    preferredRepresentation: compactRepresentation
    fullRepresentation: CalendarView { }
    
    compactRepresentation: Loader {
        // Content that shows on the panel
    }
}
```

### 2. Mouse Interaction

The click handling in `DigitalClock.qml` uses a `MouseArea` that toggles the expanded state:

```qml
MouseArea {
    // Various properties
    
    onPressed: wasExpanded = root.expanded
    onClicked: root.expanded = !wasExpanded
}
```

The `expanded` property is key - it controls whether the popup is displayed or hidden.

### 3. Data Flow Architecture

The widget uses a data source system to access system time and timezone information:

```qml
P5Support.DataSource {
    id: dataSource
    engine: "time"
    connectedSources: allTimeZones
    interval: /* timing logic */
}
```

This data flows between the compact and full representations to keep both synchronized.

## Implementation Steps

1. **Create Basic Structure**:
   - Define your `PlasmoidItem` with compact and full representations
   - Set up any necessary data sources

2. **Panel Representation**:
   - Implement the compact view that appears on the panel
   - Add a `MouseArea` that toggles the `root.expanded` property

3. **Popup Content**:
   - Create your full representation that appears when clicked
   - Ensure it properly sizes itself with constraints

4. **Connect Data**:
   - Ensure data flows between the compact and full representations
   - Implement event handlers for configuration changes

5. **Handle Visibility**:
   - Control when the popup disappears (on outside click, etc.)
   - Set `hideOnWindowDeactivate` property to control auto-hiding behavior

## Technical Details

- The popup anchoring is handled by the Plasma framework
- Sizing constraints are important - define `Layout.minimum/maximumWidth/Height`
- Use `Plasmoid.configuration` to store settings persistently
- Apply `Kirigami.Units` for consistent spacing and sizing
- Implement proper keyboard navigation with `KeyNavigation` properties

## Example Flow

1. User clicks on the panel widget (`MouseArea.onClicked`)
2. Code sets `root.expanded = true`
3. Plasma framework shows the `fullRepresentation` (CalendarView)
4. User can interact with the popup, or click outside to dismiss
5. When dismissed, `root.expanded` is set back to `false`

This pattern allows you to create intuitive, interactive widgets that respond to user clicks by displaying more detailed content or controls in a popup.
