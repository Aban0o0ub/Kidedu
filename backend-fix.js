// // في ملف lesson controller (الباك إند)
// exports.createLesson = async (req, res) => {
//   // ✅ إضافة youtubeVideoUrl هنا
//   const { name, description, youtubeVideoUrl } = req.body;
//   const { sectionId } = req.params;

//   try {
//     // تحقق من صلاحية السكشن
//     if (!mongoose.Types.ObjectId.isValid(sectionId)) {
//       if (req.files) req.files.forEach(file => fs.unlinkSync(file.path));
//       return res.status(400).json({ status: "Failed", message: "Invalid section ID format" });
//     }

//     const section = await sectionModel.findById(sectionId);
//     if (!section) {
//       if (req.files) req.files.forEach(file => fs.unlinkSync(file.path));
//       return res.status(404).json({ status: "Failed", message: "Section not found" });
//     }

//     if (section.instructorId.toString() !== req.userId) {
//       if (req.files) req.files.forEach(file => fs.unlinkSync(file.path));
//       return res.status(403).json({ status: "Failed", message: "Not authorized" });
//     }

//     // تجهيز روابط الصور المرفوعة
//     const images = req.files?.map(file => `/uploads/lesson-files/${file.filename}`) || [];

//     // ✅ إضافة youtubeVideoUrl هنا
//     const newLesson = await lessonModel.create({
//       name,
//       description,
//       youtubeVideoUrl, // ← إضافة هذا السطر
//       sectionId: section._id,
//       instructorId: req.userId,
//       images
//     });

//     // تحديث السكشن بإضافة الدرس الجديد
//     section.lessons.push(newLesson._id);
//     await section.save();

//     res.status(201).json({
//       status: "Success",
//       data: {
//         lesson: newLesson,
//         section: {
//           id: section._id,
//           title: section.title
//         }
//       }
//     });

//   } catch (err) {
//     // باقي الكود زي ما هو...
//     if (req.files) {
//       req.files.forEach(file => {
//         try {
//           const filePath = path.join(__dirname, '..', 'uploads', 'lesson-files', file.filename);
//           if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
//         } catch (fileErr) {
//           console.error("Error deleting file:", fileErr);
//         }
//       });
//     }

//     let errorMessage = err.message;
//     if (err.name === 'ValidationError') {
//       errorMessage = Object.values(err.errors).map(val => val.message).join(', ');
//     }

//     res.status(400).json({
//       status: "Failed",
//       message: errorMessage,
//       errorType: err.name
//     });
//   }
// }; 