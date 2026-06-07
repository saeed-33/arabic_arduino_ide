# Step 15: Friendly Errors Mapping

## Goal

Convert raw compiler diagnostics into clearer Arabic messages for learning and debugging, while keeping Raw Errors unchanged for developers.

## Implemented

Added:

- `FriendlyDiagnostic`
- `FriendlyDiagnosticMapper`

Developer Mode `Friendly Errors` now shows:

- title
- explanation
- location
- suggested fix

## Example

Raw compiler diagnostic:

```text
extraneous input 'اكتب' expecting {<EOF>, 'متغير', FUNCTION}
```

Friendly diagnostic:

```text
رمز في مكان غير مناسب
وجد المترجم "اكتب" في مكان لا تسمح به قواعد اللغة الحالية.
اقتراح: تأكد أن البرنامج يبدأ بتعريف متغير أو تعريف دالة. الأوامر مثل "اكتب" يجب أن تكون داخل دالة أو بلوك يسمح بالجمل.
```

## Compiler Boundary

The IDE does not implement compiler logic.

The mapper only translates compiler diagnostics into user-facing explanations. Raw compiler output remains available in `Raw Errors`.

## Current Mapping Rules

Supported friendly mappings:

- parser `extraneous input`
- parser `missing`
- fallback message for unknown diagnostics

## Help Section Update

The Help section now explains that Friendly Errors shows simplified Arabic explanations and suggested fixes.

## Next Step Suggestion

Start planning Learning Mode:

- block palette
- workspace
- block-to-source preview
- learner-friendly run feedback
- compiler diagnostics translated into simple hints
