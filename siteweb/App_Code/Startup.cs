using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Nortekmed2015.Startup))]
namespace Nortekmed2015
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
