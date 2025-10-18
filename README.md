# DocuSealKit

A Swift client for the [DocuSeal API](https://www.docuseal.com/docs/api) built with AsyncHTTPClient for seamless electronic signature and document management.

## Requirements

- Linux
- macOS 14.0+
- Swift 6+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file's dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/thoven87/docuseal-kit.git", from: "2.0.0")
]
```

Then in your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["DocuSealKit"]),
]
```

## Usage

### Initialize the client

```swift
import DocuSealKit

let client = DocuSealClient(apiKey: "your-api-key")
```

#### EU Cloud

API keys for the EU cloud can be obtained from your [EU DocuSeal Console](https://console.docuseal.eu/api).

```swift
import DocuSealKit

let client = DocuSealClient(
    baseURL: "https://api.docuseal.eu"
    apiKey: "your-api-key",
)
```

#### On-Premises

For on-premises installations, API keys can be retrieved from the API settings page of your deployed application, e.g., https://yourdocusealapp.com/settings/api.

```swift
import DocuSealKit

let client = DocuSealClient(
    baseURL: "https://yourdocusealapp.com/api"
    apiKey: "your-api-key",
)
```

### List Templates

```swift
let templates = try await client.listTemplates()
print("Found \(templates.data.count) templates")
```

### Create a Template from PDF

```swift
let request = CreateTemplateFromPdfRequest(
    name: "Employment Contract",
    documents: [
        TemplateDocumentRequest(
            name: "Contract",
            file: "base64-encoded-pdf-content",
            fields: [
                TemplateFieldRequest(
                    name: "Signature",
                    type: "signature",
                    role: "Employee",
                    required: true,
                    areas: [
                        TemplateFieldAreaRequest(
                            x: 0.7,
                            y: 0.9,
                            w: 0.25,
                            h: 0.05,
                            page: 2
                        )
                    ]
                )
            ]
        )
    ]
)

let template = try await client.createTemplateFromPdf(request: request)
print("Created template: \(template.id)")
```

### Create a Template from HTML

```swift
let request = CreateTemplateFromHtmlRequest(
    html: "<p>This agreement between <text-field name='Company' role='Company'></text-field> and <text-field name='Customer' role='Customer'></text-field>...</p>",
    name: "Service Agreement"
)

let template = try await client.createTemplateFromHtml(request: request)
print("Created template: \(template.id)")
```

### Create a Submission

```swift
let submissionRequest = CreateSubmissionRequest(
    templateId: 1000001,
    submitters: [
        SubmissionSubmitter(
            role: "First Party",
            email: "john.doe@example.com"
        )
    ]
)

let submitters = try await client.createSubmission(request: submissionRequest)
print("Created submission for \(submitters.count) submitters")
```

### Handling Webhooks

```swift
// In your webhook handler
func handleDocuSealWebhook(requestBody: ByteBuffer) async throws {
    // Parse webhook event once - returns categorized event with parsed data
    let eventCategory = try DocusealWebhookHandler.parseWebhookEvent(from: requestBody)

    // Process based on event category
    switch eventCategory {
    case .formEvent(let event):
        print("Form event: \(event.eventType.rawValue)")
        print("Form completed: \(event.data.id)")
        // Download documents
        if let documents = event.data.documents {
            for document in documents {
                // Download document from document.url
            }
        }

    case .submissionEvent(let event):
        print("Submission event: \(event.eventType.rawValue)")
        print("Submission created: \(event.data.id)")
        // Access strongly-typed submission data
        if let status = event.data.status {
            print("Status: \(status)")
        }

    case .templateEvent(let event):
        print("Template event: \(event.eventType.rawValue)")
        print("Template updated: \(event.data.id)")
        // Access template-specific data
        print("Template name: \(event.data.name)")
    }
}
```

## Features

The client supports the following DocuSeal API endpoints:

### Templates
- List all templates
- Get a template
- Create a template from Word DOCX
- Create a template from HTML
- Create a template from PDF
- Merge templates
- Clone a template
- Update a template
- Update template documents
- Archive a template

### Submissions
- List all submissions
- Get a submission
- Get submission documents
- Create a submission
- Create submissions from emails
- Archive a submission

### Submitters
- List all submitters
- Get a submitter
- Update a submitter

### Webhooks

DocuSeal Kit supports three types of webhook events with full type safety:

#### Event Types

**Form Events:**
- `form.viewed` - Form was viewed by a submitter
- `form.started` - Form submission was started
- `form.completed` - Form was completed by a submitter
- `form.declined` - Form was declined by a submitter

**Submission Events:**
- `submission.created` - New submission was created
- `submission.archived` - Submission was archived
- `submission.completed` - All submitters completed the submission
- `submission.expired` - Submission expired

**Template Events:**
- `template.created` - New template was created
- `template.updated` - Template was updated

#### Webhook Authentication

DocuSeal uses key-value pairs in request headers for webhook authentication. Configure this in DocuSeal Console > Webhooks > Add Secret.

```swift
// Verify webhook authenticity - throws DocuSealError.webhookAuthenticationError if invalid
try DocusealWebhookHandler.verifyWebhookSecret(
    receivedKey: request.headers["X-Secret-Value"]?.first ?? "",
    expectedKey: "your-secret-value"
)
```

#### Type-Safe Event Processing

The `parseWebhookEvent` method performs single JSON decode and returns strongly-typed events:

```swift
let eventCategory = try DocusealWebhookHandler.parseWebhookEvent(from: requestBody)

switch eventCategory {
case .submissionEvent(let event):
    // event.eventType guaranteed to be submission-only:
    // .submissionCreated, .submissionArchived, .submissionCompleted, .submissionExpired
    print("Submission \(event.data.id) - \(event.eventType.rawValue)")

case .formEvent(let event):
    // event.eventType guaranteed to be form-only:
    // .formViewed, .formStarted, .formCompleted, .formDeclined
    print("Form event: \(event.eventType.rawValue)")

case .templateEvent(let event):
    // event.eventType guaranteed to be template-only:
    // .templateCreated, .templateUpdated
    print("Template \(event.data.name) - \(event.eventType.rawValue)")
}
```

## License

MIT
