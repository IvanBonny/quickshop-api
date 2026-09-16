var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
app.MapGet("/", () => "QuickShop API Running");
app.Run();
