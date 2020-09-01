# se_flutter_shop

A new Flutter project.

## Getting Started

- Divide all your files in lib into at least three folders <models><screens><widgets> and a standalone main.dart
    And create a folder called <assetd> at the outer layer to put all the fonts

    main.dart theming/routes
    <screens> start with scaffold
    <widgets> reuseable widgets
    check widget catalog often

    configure all the fonts in <pubspec.yaml>

-  State Management   
    in <widgets> you want to use routes
    Create a route on the fly. But it might be relatively hard for others to understand your code as the app gets bigger.
    And since you register a route inside one screen/widget, if you want to pass data that screen/widget doesn't have, it simply can't do that.
        onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (ctx) => ProductDetailScreen(`Pass the data you want`),
                ),
            );
        },

    The best way is to register routes in main.dart file
        <main.dart>
        routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
        <widget><product_item.dart> for example
        onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: id, `Only pass data that it has, the rest of them can be handled by main.dart`
            );
        },
        <screen><product_detail_screen.dart> extract data
        final productId = ModalRoute.of(context).settings.arguments as String;

    Why should we do this?
        Because passing data via constructors can be cumbersome and difficult.
        Unnessary rebuilds of the entire app or major parts of the app because the data that only a really deep level widget needs, has changed

    What is 'state' and 'state management'
        It's all about data and UI.
        State=Data with affects the UI (and which might change over time)

        App-wide State
            like isAuthenticated, should be handled by provider
        Widget(local) State
            price/color, can be handled by statefulwidget

        The Provider and Listener
            This is what flutter suggests
            Put all data in a widget and it is our data provider, all its child can listen to the provider.
            When the data changes, only the widget that listens to that date will rebuild.

        Flutter provider
        https://pub.dev/packages/provider/install
        
    Build a server now!
        (Device storage)
        The way we get data is not directly connect our app to a db. 
        In that way you have to storage some credentials in your code, like the .env file. (bad... uncompile it and get the info)
        Now we just have to connect it to a server in which it's impossible to crack.

        REST API
            I'm sure all of you might have worked with apis before. It's just this time you're the one that edit and use it at the same time.

        Async code
            Invented by Javascript, in which this code will run a bit longer or even fail, that will keep other code waiting or kill this process.
            So we should think of a way that it should not block other code while this is running.
            So the result of the asynchronous code should be available some time in the future.