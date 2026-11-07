import SwiftUI

@main
struct DeviceComparisonApp: App {
  var body: some Scene {
    WindowGroup { ComparisonView() }
  }
}

private struct ComparisonView: View {
  @State private var query = ""
  @State private var input: String?
  @State private var wrapped = false
  @State private var rows: [Reading] = []
  @State private var model = ""

  private var differences: [Reading] {
    rows.filter { $0.original != nil && $0.local != nil && $0.original != $0.local }
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          VStack(alignment: .leading, spacing: 4) {
            Text(model).font(.headline)
            Text(input ?? ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? Local.identifier)
              .font(.system(.subheadline, design: .monospaced)).foregroundStyle(.secondary)
          }
        } header: { Text(input == nil ? "Поточний пристрій" : "Модель за ідентифікатором") }
        Section("Розбіжності · \(differences.count)") {
          if differences.isEmpty { Text("У спільних полях значення збігаються.") }
          ForEach(differences) { reading in ReadingView(reading: reading) }
        }
        Section("Перевірити модель") {
          TextField("Наприклад, iPad17,1", text: $query)
            .textInputAutocapitalization(.never).autocorrectionDisabled()
            .onSubmit { select(query) }
          HStack {
            Button("Порівняти") { select(query) }.disabled(query.isEmpty)
            Spacer()
            Menu("Приклади") {
              ForEach(["iPad17,1", "iPhone19,4", "iPad19,2", "iPhone99,1"], id: \.self) { id in
                Button(id) { query = id; select(id) }
              }
            }
          }.buttonStyle(.borderless)
          if input != nil {
            Toggle("Обгортка симулятора", isOn: $wrapped).onChange(of: wrapped) { refresh() }
            Button("Повернутися до поточного пристрою") { query = ""; select(nil) }
          }
        }
        Section("Збіги") {
          ForEach(rows.filter { $0.original != nil && $0.original == $0.local }) { ReadingView(reading: $0) }
        }
        Section("API однієї бібліотеки") {
          ForEach(rows.filter { $0.original == nil || $0.local == nil }) { ReadingView(reading: $0) }
        }
      }
      .navigationTitle("Порівняння")
      .toolbar { Button("Оновити", systemImage: "arrow.clockwise") { refresh() } }
      .onAppear { Local.beginOrientationUpdates(); refresh() }
      .onDisappear { Local.endOrientationUpdates() }
    }
  }

  private func select(_ identifier: String?) {
    input = identifier
    refresh()
  }

  private func refresh() {
    let a = input.map(Original.mapToDevice(identifier:)) ?? Original.current
    let b = input.map(Local.mapToDevice(identifier:)) ?? Local.current
    let useWrapper = input != nil && wrapped
    let original: Original = useWrapper ? .simulator(a) : a
    let local: Local = useWrapper ? .simulator(b) : b
    model = local.description
    rows = Readings.catalog(original, local)
    if input == nil { rows += Readings.system(original, local) }
  }
}

private struct ReadingView: View {
  let reading: Reading
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(reading.field).font(.system(.subheadline, design: .monospaced).weight(.semibold))
      if let result = reading.original { LabeledContent("DeviceKit", value: result.isEmpty ? "[]" : result) }
      if let result = reading.local { LabeledContent("SwiftDeviceKit", value: result.isEmpty ? "[]" : result) }
    }.font(.footnote).textSelection(.enabled).padding(.vertical, 3)
  }
}
