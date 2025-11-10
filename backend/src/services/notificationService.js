const cron = require('node-cron');
const PlantingForm = require('../models/PlantingForm');

class NotificationService {
  constructor() {
    this.notificationHandlers = [];
  }

  // Register a handler for notifications (e.g., email, push notification)
  registerHandler(handler) {
    this.notificationHandlers.push(handler);
  }

  // Send notification through all registered handlers
  async sendNotification(notification) {
    const results = await Promise.allSettled(
      this.notificationHandlers.map(handler => handler(notification))
    );
    return results;
  }

  // Check for upcoming harvests and send notifications
  async checkUpcomingHarvests() {
    try {
      const now = new Date();
      const oneWeekFromNow = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);

      // Find planting forms that need harvest notifications
      const formsNeedingNotification = await PlantingForm.find({
        status: { $in: ['pending', 'approved'] },
        notificationSent: false,
        expectedHarvestDate: {
          $gte: now,
          $lte: oneWeekFromNow
        }
      }).populate('variety');

      console.log(`Found ${formsNeedingNotification.length} forms needing harvest notification`);

      for (const form of formsNeedingNotification) {
        const daysUntilHarvest = Math.ceil(
          (form.expectedHarvestDate - now) / (1000 * 60 * 60 * 24)
        );

        const notification = {
          type: 'HARVEST_REMINDER',
          title: 'Próxima Cosecha',
          message: `La cosecha de ${form.variety.name} en ${form.farmName} - Lote ${form.lotNumber} está programada para ${daysUntilHarvest} días. Por favor confirme la fecha de cosecha.`,
          data: {
            plantingFormId: form._id,
            farmName: form.farmName,
            lotNumber: form.lotNumber,
            variety: form.variety.name,
            expectedHarvestDate: form.expectedHarvestDate,
            daysUntilHarvest
          },
          producerId: form.producerId
        };

        // Send notification through all handlers
        await this.sendNotification(notification);

        // Mark as notified
        form.notificationSent = true;
        form.notificationDate = now;
        await form.save();

        console.log(`Notification sent for form ${form._id}`);
      }

      return formsNeedingNotification.length;
    } catch (error) {
      console.error('Error checking upcoming harvests:', error);
      throw error;
    }
  }

  // Start the cron job to check for notifications daily at 8 AM
  startCronJob() {
    // Run every day at 8:00 AM
    cron.schedule('0 8 * * *', async () => {
      console.log('Running harvest notification check...');
      try {
        const count = await this.checkUpcomingHarvests();
        console.log(`Harvest notification check complete. Sent ${count} notifications.`);
      } catch (error) {
        console.error('Error in harvest notification cron job:', error);
      }
    });

    console.log('Harvest notification cron job started (daily at 8:00 AM)');
  }

  // Manual trigger for testing
  async triggerManualCheck() {
    return await this.checkUpcomingHarvests();
  }
}

// Singleton instance
const notificationService = new NotificationService();

// Example notification handler (console log)
notificationService.registerHandler(async (notification) => {
  console.log('=== NOTIFICATION ===');
  console.log('Type:', notification.type);
  console.log('Title:', notification.title);
  console.log('Message:', notification.message);
  console.log('Producer ID:', notification.producerId);
  console.log('Data:', JSON.stringify(notification.data, null, 2));
  console.log('==================');
  
  // In a real implementation, this would:
  // - Send push notification to mobile device
  // - Send email notification
  // - Create in-app notification record
  return { success: true };
});

module.exports = notificationService;
