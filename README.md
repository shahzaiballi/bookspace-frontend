# Readify - The Smart Chunked Reading Ecosystem

Welcome to **Readify**, a premium Flutter application designed to transform reading into a frictionless, smart, and highly retentive habit. 

## Key Features (The USP)

*   **Chunked Reading Mode**: Break down long books into manageable 2-5 minute reading sessions. Stuck on a complex paragraph? Trigger the "Magic Sparkle" AI Simplify to generate a crystal clear summary instantly.
*   **Fluid UI/UX**: Experience a highly polished reading environment featuring bespoke Slide-and-fade chunk transitions and dynamic Multi-theme support (Midnight, Sepia, OLED Black).
*   **Smart Notifications**: Stay consistent via local push reminders that dynamically embed text snippets from your *next* unread chunk. Tapping a notification elegantly deep-links you exactly where you left off.
*   **Social Loop**: Found a meaningful quote? Highlight any text and leverage the native "Post to Discussion" integration to spark a conversation with the Readify community instantly.
*   **Flashcard System**: Test your knowledge retention with an engaging, premium 3D card-flipping interface mapping core book takeaways.

## Tech Stack

*   **Framework**: Flutter
*   **State Management**: Riverpod (`flutter_riverpod`)
*   **Navigation**: GoRouter (`go_router`)
*   **Notifications**: Local Notifications (`flutter_local_notifications`)
*   **Authentication**: Google Sign-In (`google_sign_in`)

## Architecture

Readify adheres to a **Clean Modular Architecture** ensuring robust separation of concerns:
*   **Presentation Layer**: UI widget trees, feature-specific pages, and Riverpod controllers.
*   **Domain Layer**: Core business logic, Entities, and abstract Repository contracts.
*   **Data Layer**: External API implementations, Mock repositories, and system services.

## How to Run

1.  **Clone the repository** and open the project in your IDE.
2.  **Fetch dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application** (Ensure a device/emulator is connected):
    ```bash
    flutter run
    ```

### Permission Requirements
During execution, Readify utilizes vital native Android features. Ensure you test these flows dynamically:
*   **Storage Access**: Requested gracefully when importing custom `.pdf` or `.epub` files into your reading library.
*   **Alarms & Scheduling**: Necessary to schedule time-sensitive exact alarms for the smart chunk reminders.
