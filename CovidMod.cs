using System;
using Microsoft.Xna.Framework;
using StardewModdingAPI;
using StardewModdingAPI.Events;
using StardewModdingAPI.Utilities;
using StardewValley;

namespace CovidMod
{
    public class ModEntry : Mod
    {
        public override void Entry(IModHelper helper)
        {
            helper.Events.GameLoop.OneSecondUpdateTicked += this.OnSecondUpdateTicked;
            helper.Events.Input.ButtonPressed += this.OnButtonPressed;
        }

        private void OnSecondUpdateTicked(object sender, OneSecondUpdateTickedEventArgs e)
        {

            // ignore if player hasn't loaded a save yet
            if (!Context.IsWorldReady)
                return;

            this.Monitor.Log("Calculating COVID transmission");

            Point playerLocation = Game1.player.getTileLocationPoint();
            this.Monitor.Log($"found player at ({playerLocation.X},{playerLocation.Y})");

            // Find all character positions
            using (DisposableList<NPC>.Enumerator enumerator = Utility.getAllCharacters().GetEnumerator())
            {
                while (enumerator.MoveNext())
                {
                    NPC current = enumerator.Current;
                    Point characterLocation = current.getTileLocationPoint();
                    this.Monitor.Log($"found character {current.getName()} at position ({characterLocation.X},{characterLocation.Y})");
                }
            }
        }

        private void OnButtonPressed(object sender, ButtonPressedEventArgs e)
        {
            // ignore if player hasn't loaded a save yet
            if (!Context.IsWorldReady)
                return;

            // print button presses to the console window
            //this.Monitor.Log($"{Game1.player.Name} pressed {e.Button}.", LogLevel.Debug);
            this.Monitor.Log($"{Game1.player.name} pressed {e.Button}.", LogLevel.Debug);
        }
    }
}
